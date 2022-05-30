resource "aws_iam_role" "codebuild_role" {
  name               = "gorilla-codebuild-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "timeoff_mgmt_policy" {
  role   = aws_iam_role.codebuild_role.name
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1653878744732",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::lguerratest/gorilla-test/Dockerrun.aws.json"
    },
    {
      "Sid": "Stmt1653878909769",
      "Action": [
        "ecr:PutImage"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:ecr:us-west-2:593526201844:repository/timeoff"
    },
    {
      "Sid": "Stmt1653879379851",
      "Action": [
        "elasticbeanstalk:CreateApplicationVersion"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:elasticbeanstalk:us-west-2:593526201844:application/*"
    },
    {
      "Sid": "Stmt1653879416783",
      "Action": [
        "elasticbeanstalk:UpdateEnvironment"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:elasticbeanstalk:us-west-2:593526201844:environment/*"
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "cicd_timeoff" {
  name          = "CICD-timeoff"
  description   = "cicd-for-timeoff"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = 60

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type                = "GITHUB"
    location            = "https://github.com/lg-guerra-g/timeoff-management-application.git"
    git_clone_depth     = 1
    report_build_status = true
  }

  source_version = "master"
}

resource "aws_codebuild_webhook" "timeoff_webhook" {
  project_name = aws_codebuild_project.cicd_timeoff.name
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }
    filter {
      type    = "HEAD_REF"
      pattern = "master"
    }
  }
}