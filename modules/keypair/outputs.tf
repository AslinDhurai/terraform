output "key_name" {
  value = aws_key_pair.this.key_name
}

output "private_key_path" {
  value = local_file.private_key.filename
}

output "instance_ip" {
  value = aws_instance.this.public_ip
}
