# GoMARL-MATE

Mã nguồn cho các thí nghiệm **Multi-Agent Reinforcement Learning (MARL)** với:

- **GoMARL**: framework huấn luyện multi-agent, bao gồm QMIX/group learner và
  các môi trường StarCraft II/SMAC và MATE.
- **MATE**: môi trường mô phỏng theo dõi đa tác tử
  ([Multi-Agent Tracking Environment](https://github.com/XuehaiPan/mate)).

## Cấu trúc dự án

```text
GoMARL-MATE/
├── GoMARL/       # Mã huấn luyện MARL và các cấu hình thí nghiệm
└── MATE-main/    # Môi trường MATE, agent, wrapper và ví dụ
```

## Yêu cầu hệ thống

- Python **3.11.x** (khuyến nghị cho GoMARL).
- Linux hoặc macOS cho các script `.sh` và StarCraft II/SMAC.
- GPU NVIDIA và CUDA nếu muốn huấn luyện bằng GPU.
- Git.

> Trên Windows, phần `MATE-main` có thể chạy bằng PowerShell. Các script
> `install_sc2.sh`, `install_dependencies.sh` và `run.sh` là script Bash, nên
> cần dùng WSL hoặc môi trường Linux tương thích.

## Cài đặt MATE

MATE-main sử dụng [uv](https://docs.astral.sh/uv/). Từ thư mục gốc:

```bash
cd MATE-main
python -m pip install uv
uv sync
```

Kích hoạt môi trường ảo:

```bash
# Linux/macOS
source .venv/bin/activate

# Windows PowerShell
.\.venv\Scripts\Activate.ps1
```

Chạy ví dụ tương tác với môi trường MATE:

```bash
python example.py
```

Ví dụ sử dụng environment đã đăng ký bằng Gymnasium:

```python
import gymnasium as gym
import mate

env = gym.make("MultiAgentTracking-v0", config="MATE-4v8-9.yaml")
```

Các cấu hình môi trường nằm trong
[`MATE-main/mate/assets/`](./MATE-main/mate/assets/).

## Cài đặt GoMARL

Từ thư mục gốc, tạo một môi trường Python riêng cho GoMARL:

```bash
cd GoMARL
conda create -n gomarl python=3.11.2 -y
conda activate gomarl
```

Cài PyTorch. Lệnh dưới đây dùng CUDA 12.1; hãy thay đổi theo phiên bản CUDA
phù hợp với máy:

```bash
conda install pytorch::pytorch torchvision pytorch::pytorch-cuda=12.1 \
  -c pytorch -c nvidia -y
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

### Cài StarCraft II và bản đồ SMAC

Trên Linux, chạy:

```bash
cd GoMARL
bash install_sc2.sh
```

Script cài StarCraft II vào `$HOME/StarCraftII`, tải bản đồ SMAC và thiết lập
thư mục bản đồ. Nếu đã cài StarCraft II ở vị trí khác, đặt biến môi trường
`SC2PATH` tương ứng trước khi chạy chương trình.

## Chạy thí nghiệm GoMARL

Luôn chạy lệnh từ thư mục `GoMARL` để các đường dẫn cấu hình tương đối hoạt
động chính xác:

```bash
cd GoMARL
```

### Chạy một thí nghiệm

Cú pháp:

```bash
python src/main.py --config=<algorithm> --env-config=<environment> \
  with env_args.map_name=<map>
```

Ví dụ QMIX/group learner trên StarCraft II:

```bash
python src/main.py --config=group --env-config=sc2 \
  with env_args.map_name=3m
```

Ví dụ chạy trên môi trường MATE:

```bash
python src/main.py --config=group --env-config=mate
```

Các file cấu hình chính:

- [`GoMARL/src/config/algs/group.yaml`](./GoMARL/src/config/algs/group.yaml):
  cấu hình group learner/QMIX.
- [`GoMARL/src/config/envs/sc2.yaml`](./GoMARL/src/config/envs/sc2.yaml):
  cấu hình StarCraft II.
- [`GoMARL/src/config/envs/mate.yaml`](./GoMARL/src/config/envs/mate.yaml):
  cấu hình MATE.
- [`GoMARL/src/config/default.yaml`](./GoMARL/src/config/default.yaml):
  giá trị mặc định như số timestep, logging và checkpoint.

Có thể ghi đè tham số trực tiếp, ví dụ:

```bash
python src/main.py --config=group --env-config=sc2 \
  with env_args.map_name=3m t_max=100000 use_cuda=False
```

Kết quả, log Sacred và model checkpoint được lưu trong thư mục `GoMARL/results`
theo cấu hình chạy.

### Chạy nhiều seed/GPU

Script `run.sh` hỗ trợ chạy nhiều map, nhiều lần lặp và phân phối theo GPU:

```bash
bash run.sh <config> <env_config> <map_list> [args] [threads] [gpu_list] [times]
```

Ví dụ:

```bash
bash run.sh group sc2 3m,8m "" 2 0,1 5
```

Tham số `""` là danh sách tham số ghi đè bổ sung (để trống trong ví dụ);
`2` là số thread, `0,1` là danh sách GPU và `5` là số lần chạy cho mỗi map.
Khi dùng script này, hãy kiểm tra lại giới hạn GPU/RAM và các tham
số trong file cấu hình trước khi chạy quy mô lớn.

## Dọn kết quả

Dừng các tiến trình Python của user hiện tại:

```bash
bash clean.sh
```

Xóa thêm kết quả Sacred:

```bash
bash clean.sh all
```

## Phát triển và kiểm thử

MATE-main có các notebook thử nghiệm:

- [`MATE-main/test.ipynb`](./MATE-main/test.ipynb)
- [`MATE-main/test_rl.ipynb`](./MATE-main/test_rl.ipynb)

Sau khi cài môi trường MATE, có thể khởi động Jupyter bằng:

```bash
cd MATE-main
uv run jupyter notebook
```

## Giấy phép

Xem file [GoMARL/LICENSE](./GoMARL/LICENSE) để biết thông tin giấy phép của
phần GoMARL. Phần MATE giữ các thông tin package và giấy phép theo mã nguồn
trong thư mục [`MATE-main/`](./MATE-main/).
