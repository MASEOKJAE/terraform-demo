# 🌍 Terraform Demo - AWS 인프라 자동화 구축

![image](https://github.com/user-attachments/assets/db4c4804-a389-428c-991e-d75d35307159)

## 📌 개요

### 🔍 Terraform Demo란?

**Terraform Demo**는 **AWS 클라우드 환경을 자동으로 구축**하는 Terraform 코드입니다.
Terraform을 활용하여 **VPC, EC2 인스턴스, 로드 밸런서, 오토 스케일링 그룹** 등의 인프라를 자동으로 배포할 수 있습니다.

### 🎯 주요 기능

- **AWS 인프라 자동화**: 코드 한 줄로 AWS 리소스를 자동 구축 🚀
- **모듈화된 구성**: 재사용 가능한 **Terraform 모듈** 사용 🏗️
- **멀티 환경 지원**: `stage` 및 `prod` 환경 설정 가능 🏢
- **Auto Scaling 적용**: 트래픽 증가에 따라 EC2 인스턴스 자동 확장 📈
- **로드 밸런서 구성**: ALB를 통해 트래픽 분산 ⚖️
- **보안 그룹 설정**: SSH, HTTP/S 포트 관리 🔒

---

## 🛠️ 기술 스택

| 기술 | 설명 |
| --- | --- |
| 🌍 **Terraform** | 인프라 코드(IaC) 관리 도구 |
| ☁️ **AWS (EC2, ALB, Auto Scaling, VPC, S3)** | 클라우드 인프라 |
| 🔐 **IAM & Security Group** | AWS 접근 제어 및 네트워크 보안 |
| 📜 **HCL (HashiCorp Configuration Language)** | Terraform 설정 언어 |

---

## 📂 폴더 구조 및 설명

```yaml
terraform-demo/
├── main.tf                 # 최상위 Terraform 설정 (별도 리소스 정의 없음)
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

---

### 📌 폴더별 역할

### **1️⃣ `main.tf` (최상위 루트)**

Terraform의 **메인 설정 파일**이지만, 별도의 리소스를 정의하지 않고 `modules` 및 `stage` 내 환경을 관리하는 용도로 사용됩니다.

### **2️⃣ `variables.tf`**

Terraform에서 사용되는 **변수 값**을 정의하여 설정 값을 쉽게 변경할 수 있도록 합니다.

### **3️⃣ `outputs.tf`**

Terraform이 생성한 리소스에서 **필요한 정보를 출력**할 수 있도록 정의합니다. (예: ALB DNS, EC2 Public IP)

### **4️⃣ `terraform.tfstate / terraform.tfstate.backup`**

Terraform이 현재 상태를 저장하는 파일로, 클라우드 리소스의 상태를 추적하는 데 사용됩니다. (실행 후 생성됨)

### **5️⃣ `modules/` (모듈화된 설정)**

재사용 가능한 Terraform **모듈**을 관리하는 디렉토리로, **웹 서버 클러스터** 등을 배포하는 데 사용됩니다.

- `modules/services/webserver-cluster/main.tf` → 웹 서버 클러스터 (EC2, ALB, Auto Scaling) 설정 포함

### **6️⃣ `stage/` (스테이징 환경 구성)**

운영 환경 배포 전에 테스트할 수 있는 환경을 구성하는 곳입니다. stage 환경에서 `terraform init` 후 `terraform apply`를 실행하면 테스트 가능한 인프라가 배포됩니다.

### **7️⃣ `storage/` (원격 상태 저장소)**

Terraform의 상태 파일을 저장하는 **S3 백엔드** 설정을 포함할 수 있습니다.

---

## 🚀 Terraform 환경 구축 방법

### 🏗️ 단계별 실행 방법

1️⃣ **모듈(`webserver-cluster`) 초기화 및 적용**

```bash
cd modules/services/webserver-cluster
terraform init
terraform apply -auto-approve
```

2️⃣ **Stage 환경 초기화 및 적용**

```bash
cd ../../../stage/services/webserver-cluster
terraform init
terraform apply -auto-approve
```

3️⃣ **최상위 `main.tf` 적용**

```bash
cd ../../..
terraform init
terraform apply -auto-approve
```

> ✅ 위 과정을 통해 모든 환경이 올바르게 배포됩니다.
> 

---

## 🔎 Terraform Output을 확인하는 방법

Terraform은 `root`에서는 output 정보를 직접 확인할 수 없습니다.

따라서 **Stage 환경의 `webserver-cluster`로 이동하여 Terraform output을 확인해야 합니다.**

```bash
cd stage/services/webserver-cluster
terraform output
```

출력 예시:

```bash
alb_dns_name = "terraform-asg-example-1140209627.ap-northeast-2.elb.amazonaws.com"
```

> 📌 왜 root에서 output이 안 나오나요?
> 
> 
> root에는 `outputs.tf`가 없고, 모든 리소스가 모듈 및 `stage`에서 생성되므로, output을 확인하려면 해당 리소스가 정의된 디렉토리에서 실행해야 합니다.
> 

---

## 🔎 코드 상세 설명

### 📌 `modules/services/webserver-cluster/main.tf`

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

> ✅ EC2 인스턴스 설정 (AMI, 인스턴스 타입, 보안 그룹 포함)
✅ user_data 스크립트로 기본 웹 서버 자동 실행
> 

---

## 💡 FAQ

### ❓ Terraform 적용 후 AWS 콘솔에서 변경하면 어떻게 되나요?

Terraform 상태와 실제 리소스가 달라지며, `terraform plan` 실행 시 변경 사항을 감지합니다.

### ❓ Terraform 적용 후 롤백이 가능한가요?

Terraform은 상태 파일(`terraform.tfstate`)을 사용하여 **리소스 삭제 및 복원**을 수행할 수 있습니다.

---

## 🎉 결론

이 실습 코드는 **Terraform을 활용한 AWS 인프라 자동 구축**을 보여줍니다.

누구나 간단한 설정만으로 **AWS에서 Auto Scaling 웹 서버를 배포**할 수 있습니다! 🚀

> 📩 문의: maasj7514@gmail.com
> 
> 
> 📂 GitHub: [terraform-demo](https://github.com/MASEOKJAE/terraform-demo)
>
