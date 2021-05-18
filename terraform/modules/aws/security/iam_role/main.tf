# 既存POLICY取得
data "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
}

//data "aws_iam_policy" "AmazonEC2ContainerServiceEventsRole" {
//  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
//}
//
//data "aws_iam_policy" "AmazonEC2ContainerRegistryFullAccess" {
//  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
//}
//
//data "aws_iam_policy" "AmazonS3FullAccess" {
//  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
//}
//
//data "aws_iam_policy" "AmazonAPIGatewayPushToCloudWatchLogs" {
//  arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
//}
//
//# 新規IAM ROLE作成
//resource "aws_iam_role" "ecsEventsRole" {
//  name = "ecsEventsRole"
//
//  assume_role_policy = <<EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Sid": "",
//      "Effect": "Allow",
//      "Principal": {
//        "Service": "events.amazonaws.com"
//      },
//      "Action": "sts:AssumeRole"
//    }
//  ]
//}
//EOF
//}
//
//resource "aws_iam_role" "ecsTaskRole" {
//  name = "ecsTaskRole"
//
//  assume_role_policy = <<EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Action": "sts:AssumeRole",
//      "Principal": {
//        "Service": "ecs-tasks.amazonaws.com"
//      },
//      "Effect": "Allow",
//      "Sid": ""
//    }
//  ]
//}
//EOF
//}
//
//# IAM ROLEにPOLICYをアタッチ
//resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceEventsRole" {
//  role       = aws_iam_role.ecsEventsRole.id
//  policy_arn = data.aws_iam_policy.AmazonEC2ContainerServiceEventsRole.arn
//}
//
//resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryFullAccess" {
//  role       = aws_iam_role.ecsTaskRole.id
//  policy_arn = data.aws_iam_policy.AmazonEC2ContainerRegistryFullAccess.arn
//}
//
//resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess" {
//  role       = aws_iam_role.ecsTaskRole.id
//  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
//}
//
//resource "aws_iam_role_policy_attachment" "AmazonAPIGatewayPushToCloudWatchLogs" {
//  role       = aws_iam_role.ecsTaskRole.id
//  policy_arn = data.aws_iam_policy.AmazonAPIGatewayPushToCloudWatchLogs.arn
//}
