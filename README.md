# GitHub Actions - CI/CD for Docker Hub

## 📌 Mục tiêu

Tự động build và push Docker image lên Docker Hub mỗi khi push code lên nhánh `main`.

## 📦 Các thành phần

- **`.github/workflows/deploy.yml`**: GitHub Actions workflow
- **`Dockerfile`**: Build Java Spring Boot application
- **`pom.xml`**: Maven configuration
- **`src/`**: Java source code

## 🚀 Hướng dẫn thiết lập

### 1️⃣ Thiết lập GitHub Secrets

Trước khi chạy workflow, cần setup 2 secrets:

1. Vào **Settings → Secrets and variables → Actions**
2. Tạo **DOCKER_USERNAME**: Docker Hub username (ví dụ: `adminkiet`)
3. Tạo **DOCKER_PASSWORD**: Docker Hub password hoặc Personal Access Token

Chi tiết xem: [GITHUB_ACTIONS_SETUP.md](./GITHUB_ACTIONS_SETUP.md)

### 2️⃣ Push code lên GitHub

```bash
git add .
git commit -m "Add GitHub Actions workflow"
git push origin main
```

### 3️⃣ Kiểm tra Pipeline

- Vào GitHub Repository → **Actions tab**
- Xem status build (xanh lá = success, đỏ = failed)

## 📊 Workflow tự động làm gì

1. **Trigger**: Mỗi khi push code lên nhánh `main`
2. **Checkout**: Tải code từ repository
3. **Docker Login**: Đăng nhập vào Docker Hub (dùng GitHub Secrets)
4. **Build & Push**: Build image từ Dockerfile và push lên Docker Hub
5. **Tags**: Tạo 2 tags:
   - `username/kietimage:latest` - Phiên bản mới nhất
   - `username/kietimage:commit-sha` - Phiên bản theo commit

## 🔍 Kiểm tra image trên Docker Hub

Sau khi build thành công:

```bash
# Pull image
docker pull adminkiet/kietimage:latest

# Run container
docker run -d -p 8080:8080 adminkiet/kietimage:latest
```

## 📝 File cấu trúc

```
.
├── .github/
│   └── workflows/
│       ├── deploy.yml                    # ⭐ Main workflow
│       └── hello-world.yml               # Example workflow
├── src/
│   ├── main/
│   │   ├── java/com/example/.../
│   │   │   ├── PhanlamtuankietApplication.java
│   │   │   └── HelloController.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
├── Dockerfile                            # Build image
├── pom.xml                               # Maven config
├── README.md                             # This file
└── GITHUB_ACTIONS_SETUP.md               # Detailed setup guide
```

## ✅ Các bước đã hoàn tất

- [x] Tạo workflow `.github/workflows/deploy.yml`
- [x] Thêm Dockerfile
- [x] Thêm Java source code
- [x] Thêm configuration files
- [ ] Setup GitHub Secrets (cần bạn làm)
- [ ] Push code lên main branch (cần bạn làm)

## 🔗 Liên kết hữu ích

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Docker GitHub Actions](https://github.com/docker/build-push-action)
- [Docker Hub](https://hub.docker.com)

---

**Bước tiếp theo**: Xem [GITHUB_ACTIONS_SETUP.md](./GITHUB_ACTIONS_SETUP.md) để thiết lập GitHub Secrets!

