# 🌍 Terraform Demo - AWS 인프라 자동화 구축

![image](https://github.com/user-attachments/assets/1b2226c6-41a7-4b37-b9d8-7f5084c3201c)

## 📌 0. 개요

### 🔍 0.1 Terraform Demo란?

**Terraform Demo**는 **AWS 클라우드 환경을 자동으로 구축**하는 Terraform 코드입니다.

Terraform을 활용하여 **VPC, EC2 인스턴스, 로드 밸런서, 오토 스케일링 그룹** 등의 인프라를 자동으로 배포할 수 있습니다.

### 🎯 0.2 주요 기능

- **AWS 인프라 자동화**: 코드 한 줄로 AWS 리소스를 자동 구축 🚀
- **모듈화된 구성**: 재사용 가능한 **Terraform 모듈** 사용 🏗️
- **멀티 환경 지원**: `stage` 및 `prod` 환경 설정 가능 🏢
- **Auto Scaling 적용**: 트래픽 증가에 따라 EC2 인스턴스 자동 확장 📈
- **로드 밸런서 구성**: ALB를 통해 트래픽 분산 ⚖️
- **보안 그룹 설정**: SSH, HTTP/S 포트 관리 🔒

---

## 🛠️ 1. 기술 스택

| 기술 | 설명 |
| --- | --- |
| 🌍 **Terraform** | 인프라 코드(IaC) 관리 도구 |
| ☁️ **AWS (EC2, ALB, Auto Scaling, VPC, S3)** | 클라우드 인프라 |
| 🔐 **IAM & Security Group** | AWS 접근 제어 및 네트워크 보안 |
| 📜 **HCL (HashiCorp Configuration Language)** | Terraform 설정 언어 |

---

## 📂 2. 폴더 구조

```
terraform-demo/
├── main.tf                 # 기본 Terraform 설정
├── variables.tf            # 변수 정의
├── outputs.tf              # 출력 값 정의
├── terraform.tfstate       # 상태 파일 (실행 후 생성됨)
├── terraform.tfstate.backup # 상태 파일 백업
├── modules/                # 재사용 가능한 Terraform 모듈
│   ├── services/
│   │   ├── webserver-cluster/
│   │   │   ├── main.tf        # 웹 서버 클러스터 정의
│   │   │   ├── variables.tf   # 변수 정의
│   │   │   ├── outputs.tf     # 출력 값 정의
├── stage/                  # Stage 환경 구성
│   ├── services/
│   │   ├── webserver-cluster/
│   │   │   ├── main.tf       # Stage용 웹 서버 클러스터 설정
└── storage/                # 백엔드 상태 저장소
```

### 🏗️ 폴더별 역할

| 폴더/파일 | 설명 |
| --- | --- |
| `main.tf` | 기본 Terraform 설정 파일 |
| `variables.tf` | 전역 변수 정의 |
| `outputs.tf` | 주요 리소스의 출력값 정의 (예: ALB DNS) |
| `terraform.tfstate` | Terraform 실행 후 AWS 상태 정보 저장 |
| `modules/` | 재사용 가능한 Terraform 모듈 |
| `stage/` | 스테이징 환경 (운영 환경 이전 테스트용) |
| `storage/` | Terraform 상태 관리용 원격 스토리지 |

---

## 🚀 3. Terraform 환경 구축 방법

### 🏗️ 3.1 사전 준비

Terraform을 실행하기 위해 다음 도구를 설치하세요:

- Terraform ⬇️
- [AWS CLI](https://aws.amazon.com/cli/) ⬇️
- [Git](https://git-scm.com/) ⬇️

### 🛠️ 3.2 AWS 자격 증명 설정

```bash
aws configure
```

AWS Access Key, Secret Key, Region 등을 입력하세요.

---

### 📥 3.3 실습 코 다운로드

```bash
git clone https://github.com/MASEOKJAE/terraform-demo.git
cd terraform-demo
```

---

### 🔧 3.4 Terraform 초기화

Terraform을 사용하기 전에 **초기화**가 필요합니다.

```bash
terraform init
```

> 💡 이 작업은 provider 및 모듈을 다운로드합니다.
> 

---

### 🧐 3.5 Terraform 실행 계획 확인

적용 전 **미리 보기**를 할 수 있습니다.

```bash
terraform plan
```

---

### 🚀 3.6 인프라 배포

```bash
terraform apply
```

> ✅ 적용을 진행할까요? 라는 메시지가 나오면 yes 입력하세요.
> 

---

### 🌎 3.7 생성된 리소스 확인

Terraform 적용이 완료되면 아래 명령어로 **출력 값(ALB DNS 등)** 을 확인할 수 있습니다.

```bash
terraform output
```

---

### 🗑️ 3.8 인프라 삭제

```bash
terraform destroy
```

> ❗ 주의: 모든 AWS 리소스가 삭제됩니다!
> 

---

## 🔎 4. 코드 상세 설명

### 📌 4.1 `main.tf` - 기본 설정

```hcl
provider "aws" {
  region = "ap-northeast-2"
}

module "webserver_cluster" {
  source       = "../../../modules/services/webserver-cluster"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}
```

> provider "aws" : AWS 리전 설정module "webserver_cluster" : 웹 서버 클러스터 모듈 호출
> 

---

### 📌 4.2 `modules/services/webserver-cluster/main.tf`

```hcl
resource "aws_launch_configuration" "example" {
  image_id        = "ami-0fb653ca2d3203ac1"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
  EOF

  lifecycle {
    create_before_destroy = true
  }
}
```

> aws_launch_configuration : EC2 인스턴스 설정 (AMI, 인스턴스 타입, 보안 그룹)user_data : 서버 초기 설정 스크립트 (Hello World 웹 페이지 실행)
> 

---

### 📌 4.3 `terraform.tfstate` (상태 관리)

Terraform은 상태 파일을 통해 현재 **AWS 리소스 상태**를 관리합니다.

> 💡 버전 관리 & 협업을 위해 S3 백엔드 사용을 권장합니다.
> 

---

## 🔥 5. 인프라 아키텍처

> Terraform을 실행하면 위와 같은 AWS 인프라가 자동으로 배포됩니다.
> 

---

## 💡 6. FAQ

### ❓ Terraform 적용 후 AWS 콘솔에서 변경하면 어떻게 되나요?

Terraform 상태와 실제 리소스가 달라지며, `terraform plan` 실행 시 변경 사항을 감지합니다.

### ❓ Terraform 적용 후 롤백이 가능한가요?

Terraform은 상태 파일(`terraform.tfstate`)을 사용하여 **리소스 삭제 및 복원**을 수행할 수 있습니다.

---

## 🎉 7. 결론

이 실습 코드는 **Terraform을 활용한 AWS 인프라 자동 구축**을 보여줍니다.

누구나 간단한 설정만으로 **AWS에서 Auto Scaling 웹 서버를 배포**할 수 있습니다! 🚀

> 
> 📩 문의: **maasj7514@gmail.com**
> 
> 📂 GitHub: [terraform-demo](https://github.com/MASEOKJAE/terraform-demo)
>
