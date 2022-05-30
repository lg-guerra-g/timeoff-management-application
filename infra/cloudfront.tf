resource "aws_cloudfront_distribution" "timeoff_distr" {
  enabled         = true
  price_class     = "PriceClass_100"
  is_ipv6_enabled = true

  origin {
    domain_name = aws_elastic_beanstalk_environment.timeoff_mgmt_env.cname
    origin_id   = "timeoff-beanstalk"
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "timeoff-beanstalk"
    viewer_protocol_policy = "allow-all"
    compress               = true
    response_headers_policy_id = "60669652-455b-4ae9-85a4-c4c02393f86c"
    forwarded_values {
      headers = ["*"]
      query_string = true
      query_string_cache_keys = []
      cookies {
        forward = "all"
        whitelisted_names = []
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}