# คู่มือการติดตั้ง FaceFusion One Click

## ภาพรวม

**FaceFusion** เป็นเครื่องมือที่ใช้เทคโนโลยี AI และ Deep Learning ในการผสมผสานลักษณะใบหน้าเข้ากับสื่อชนิดต่างๆ โครงการนี้อัตโนมัติในการติดตั้งและตรวจสอบการตั้งค่าต่างๆ ให้พร้อมใช้งาน โดยจะติดตั้ง dependencies ที่จำเป็นทั้งหมดอย่างถูกต้อง

สคริปต์การติดตั้งจะทำการตรวจสอบหลายๆ อย่างเพื่อให้ระบบพร้อมใช้งาน รวมถึงการตรวจสอบสภาพแวดล้อม การติดตั้งไดรเวอร์ที่จำเป็น เช่น CUDA และการติดตั้ง Miniconda Embeded พร้อมกับไลบรารีและเครื่องมือที่ต้องการ

## คุณสมบัติ

- การติดตั้ง Miniconda Embeded อัตโนมัติ (หากยังไม่ได้ติดตั้ง)
- ตรวจสอบและติดตั้งไดรเวอร์ NVIDIA CUDA ที่จำเป็น
- ตรวจสอบว่า Conda environment ที่ต้องการมีอยู่หรือไม่ และสร้างใหม่ถ้าจำเป็น
- ดาวน์โหลดและติดตั้งแพ็กเกจที่ขาดจากไฟล์ `requirements.txt`
- ตรวจสอบและติดตั้ง CUDA Runtime และ cuDNN สำหรับการรองรับ GPU
- โคลน **FaceFusion** repository จาก GitHub หากยังไม่ได้โคลน

## การติดตั้งและการใช้งาน

### ข้อกำหนดเบื้องต้น

1. **ระบบปฏิบัติการ:** Windows (ทดสอบบน Windows 10/11)
2. **ข้อกำหนดด้านฮาร์ดแวร์:**
   - การ์ดกราฟิก NVIDIA ที่รองรับ CUDA
   - RAM ขั้นต่ำ 8GB
3. **ข้อกำหนดด้านซอฟต์แวร์:**
   - Git
   - Miniconda Embeded (ถ้ายังไม่ได้ติดตั้ง สคริปต์จะช่วยติดตั้งให้)
   - Python 3.12
   - PIP 25.0
   - CUDA 12.8.1
   - cuDNN 9.8.0.87

### ขั้นตอนการติดตั้งและตั้งค่า
1. **สร้างโฟลเดอร์สำหรับการติดตั้ง FaceFusion auto install for Windows:**
   สร้างโฟลเดอร์เปล่าเพื่อจัดเก็บโปรเจค
   ```bash
   mkdir name_folder
   ```

2. **โคลน Repository:**
   โคลน **FaceFusion auto install for Windows** repository ถ้ายังไม่ได้ทำ:
   ```bash
   git clone https://github.com/rathaon-dev/facefusion-auto-windows name_folder
   ```

3. **รันสคริปต์การติดตั้ง:**
   ดาวน์โหลดสคริปต์และรันจาก `cmd` (Command Prompt) สคริปต์จะ:
   - ตรวจสอบไดรเวอร์ CUDA และติดตั้งหากจำเป็น
   - ติดตั้ง Miniconda Embeded (ถ้ายังไม่ได้ติดตั้ง)
   - สร้าง Conda environment ถ้ายังไม่มี
   - ติดตั้งแพ็กเกจ Python จาก `requirements.txt`

   รันสคริปต์โดยการดับเบิลคลิกไฟล์ `.bat` หรือรันจาก Command Prompt:
   ```bash
   auto_install_facefusion.bat
   ```

   สคริปต์จะจัดการ dependencies และการตั้งค่าทั้งหมดให้

4. **การตั้งค่าตัวแปรสภาพแวดล้อม:**
   สคริปต์จะตั้งค่าตัวแปรสภาพแวดล้อมที่จำเป็น (Miniconda Embeded และ CUDA) ให้โดยอัตโนมัติ

5. **การติดตั้งแพ็กเกจ Python ที่จำเป็น:**
   หากมีแพ็กเกจที่ขาดหายไปหรือเป็นเวอร์ชันเก่า สคริปต์จะติดตั้งให้โดยอัตโนมัติ

6. **การรัน FaceFusion:**
   หลังจากการติดตั้ง คุณสามารถรันแอปพลิเคชัน FaceFusion รันสคริปต์โดยการดับเบิลคลิกไฟล์ `.bat` หรือรันจาก Command Prompt:
   ```bash
   open_facefusion_web.bat
   ```

### ปัญหาที่พบได้บ่อยและการแก้ไข

- **ไดรเวอร์ CUDA หายไป:**
  หากเจอข้อผิดพลาด "ERROR: NVIDIA CUDA Driver not found" ให้ติดตั้งไดรเวอร์ CUDA เวอร์ชันล่าสุดจากเว็บไซต์ของ NVIDIA

- **ไม่พบ Conda Environment:**
  หากสคริปต์ไม่พบ Conda environment ให้ลบโฟลเดอร์ `conda_embeded` และ `env_facefusion` จากโฟลเดอร์ที่ติดตั้ง FaceFusion และรันสคริปต์ `auto_install_facefusion.bat` ใหม่ สคริปต์จะสร้าง environment ใหม่ให้โดยอัตโนมัติ ให้มั่นใจว่าได้ติดตั้ง Miniconda Embeded อย่างถูกต้อง


- **การติดตั้งแพ็กเกจล้มเหลว:**
  หากการติดตั้งแพ็กเกจล้มเหลว ให้ตรวจสอบการเชื่อมต่ออินเทอร์เน็ตและสิทธิ์ในการติดตั้งซอฟต์แวร์

- **ปัญหาจาก Repository:**
  หาก repository ไม่ได้ถูกโคลนหรืออัพเดตอย่างถูกต้อง สคริปต์จะพยายามแก้ไขโดยการดึงข้อมูลล่าสุดจาก GitHub

## ข้อกำหนด

- **Python** 3.12
- **Miniconda For Embeded** (สำหรับการจัดการ Python และ environment)
- **CUDA** 12.8.1
- **cuDNN** 9.8.0.87
- **PIP** 25.0
- **Git** (สำหรับการโคลน repository)
- **curl** (สำหรับดาวน์โหลด Miniconda Embeded)
- **FaceFusion GitHub repository**

### ไลบรารีเสริมที่อาจใช้:
- **onnxruntime** (สำหรับการใช้งานโมเดล ONNX)

ให้มั่นใจว่าคุณมีการเชื่อมต่ออินเทอร์เน็ตที่เสถียร เพราะสคริปต์จะดาวน์โหลด dependencies บางรายการระหว่างการติดตั้ง

## คำขอบคุณ

โครงการนี้พัฒนาขึ้นโดยใช้พื้นฐานจาก repository ของ **FaceFusion** ที่พัฒนาโดย [Original Author/Organization](https://github.com/facefusion/facefusion) ขอบคุณผู้ร่วมพัฒนาใน repository ดั้งเดิมสำหรับการทำงานที่ยอดเยี่ยม

- [Original Author/Organization](https://github.com/facefusion/facefusion)

กรุณาเยี่ยมชม repository ดั้งเดิมสำหรับเอกสารเพิ่มเติม, การอัพเดต, และการสนับสนุน
## Contact
- 📧 Email: [rathanon.dev@gmail.com](mailto:rathanon.dev@gmail.com)
- 🌐 GitHub: [github.com/rathanon-dev](https://github.com/rathanon-dev)
- 🔗 LinkedIn: [ratanon](www.linkedin.com/in/ratanon-sangrungsawang-233348327)
