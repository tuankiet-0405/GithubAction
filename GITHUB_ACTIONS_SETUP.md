# GitHub Actions CI/CD Setup Guide

## 📋 Yêu cầu

- Tài khoản GitHub
- Tài khoản Docker Hub
- Repository chứa Dockerfile và code Java Spring Boot

---

## 🔐 Bước 1: Thiết lập GitHub Secrets

GitHub Secrets giúp lưu trữ thông tin nhạy cảm (username, password) một cách an toàn.

### Cách thiết lập:

1. **Truy cập Repository**
   - Vào GitHub → Repository của bạn
   - Click `Settings` (tab phía trên)

2. **Vào Security → Secrets and variables → Actions**
   - Nếu không thấy, hãy tìm `Secrets` trong menu bên trái

3. **Tạo Secret mới: `DOCKER_USERNAME`**
   - Click `New repository secret`
   - **Name:** `DOCKER_USERNAME`
   - **Value:** Username Docker Hub của bạn (ví dụ: `adminkiet`)
   - Click `Add secret`

4. **Tạo Secret mới: `DOCKER_PASSWORD`**
   - Click `New repository secret`
   - **Name:** `DOCKER_PASSWORD`
   - **Value:** Mật khẩu Docker Hub hoặc Personal Access Token (PAT)
   - Click `Add secret`

> **Lưu ý:** Để an toàn hơn, hãy sử dụng **Personal Access Token (PAT)** thay vì mật khẩu thực:
> - Vào [Docker Hub Settings](https://hub.docker.com/settings/security)
> - Click `New Access Token`
> - Tạo token với quyền `Read & Write`
> - Copy token và dán vào Secret `DOCKER_PASSWORD`

---

## 📝 Bước 2: File Workflow (`deploy.yml`)

File workflow này sẽ:
- ✅ Chạy khi bạn push code lên nhánh `main`
- ✅ Đăng nhập vào Docker Hub using Secrets
- ✅ Build Docker image từ Dockerfile
- ✅ Push image lên Docker Hub với 2 tags: `latest` và `commit-sha`

### File được lưu tại: `.github/workflows/deploy.yml`

```yaml
name: Build and Push Docker Image

on:
  push:
    branches: ["main"]

env:
  REGISTRY: docker.io
  IMAGE_NAME: phanlamtuankiet

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build and Push to Docker Hub
        uses: docker/build-push-action@v5
        with:
          context: .
          file: ./Dockerfile
          push: true
          tags: |
            ${{ secrets.DOCKER_USERNAME }}/kietimage:latest
            ${{ secrets.DOCKER_USERNAME }}/kietimage:${{ github.sha }}
          cache-from: type=registry,ref=${{ secrets.DOCKER_USERNAME }}/kietimage:buildcache
          cache-to: type=registry,ref=${{ secrets.DOCKER_USERNAME }}/kietimage:buildcache,mode=max

  log-success:
    runs-on: ubuntu-latest
    needs: build-and-push
    if: success()
    steps:
      - name: Log Success Message
        run: echo "✅ Docker image pushed successfully to ${{ secrets.DOCKER_USERNAME }}/kietimage:latest"
```

---

## 🚀 Bước 3: Chạy Pipeline

### Cách 1: Tự động (khi push code)
```bash
git add .
git commit -m "Add GitHub Actions workflow"
git push origin main
```

Pipeline sẽ chạy tự động!

### Cách 2: Kiểm tra Pipeline
1. Vào GitHub Repository
2. Click tab `Actions`
3. Xem status build:
   - 🟢 **Success** = Build thành công
   - 🔴 **Failed** = Có lỗi, click để xem chi tiết

---

## 📊 Tags được tạo ra

Sau khi build thành công, Docker Hub sẽ có:

| Tag | Mô tả |
|-----|-------|
| `adminkiet/kietimage:latest` | Phiên bản mới nhất |
| `adminkiet/kietimage:abc1234...` | Phiên bản theo commit sha |

---

## 🐛 Kiểm tra lỗi thường gặp

| Lỗi | Giải pháp |
|-----|----------|
| "Docker login failed" | Kiểm tra Secret `DOCKER_USERNAME` và `DOCKER_PASSWORD` |
| "Dockerfile not found" | Đảm bảo `Dockerfile` nằm ở root repository |
| "Build failed" | Kiểm tra logs, xem lỗi compile hoặc lỗi Maven |
| "Can't reach registry" | Kiểm tra kết nối internet, đảm bảo Docker Hub hoạt động |

---

## 📦 Pull image từ Docker Hub

Sau khi push thành công:

```bash
# Pull latest version
docker pull adminkiet/kietimage:latest

# Pull specific version
docker pull adminkiet/kietimage:abc1234...

# Run container
docker run -d -p 8080:8080 adminkiet/kietimage:latest
```

---

## 📚 Tài liệu thêm

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Build Action](https://github.com/docker/build-push-action)
- [Docker Login Action](https://github.com/docker/login-action)
- [Docker Hub](https://hub.docker.com)

---

## ✅ Checklist hoàn tất

- [ ] Create GitHub Secrets: `DOCKER_USERNAME`
- [ ] Create GitHub Secrets: `DOCKER_PASSWORD`
- [ ] File `.github/workflows/deploy.yml` được tạo
- [ ] Push code lên nhánh `main`
- [ ] Kiểm tra tab `Actions` trong GitHub
- [ ] Xác nhận image được push lên Docker Hub

---

**Done! 🎉** GitHub Actions sẽ tự động build và push Docker image mỗi khi bạn push code lên nhánh `main`.
