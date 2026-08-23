# SmileScape — Website Lead / Appointment Form (Embed)

แบบฟอร์มนัดหมาย/ขอคำปรึกษา สำหรับฝังบน **เว็บเดิม** ระหว่างที่เว็บใหม่กำลังทำ
กรอกเสร็จ → ยิง JSON ครั้งเดียวไปที่ **n8n webhook** → n8n กระจายต่อไปยัง **อีเมลคลินิก** และ **LINE**

```
[ ผู้ใช้กรอกฟอร์มบนเว็บ ]
            │  POST JSON (1 ครั้ง)
            ▼
[ n8n Webhook ]  nexorcus.app.n8n.cloud/webhook/smilescape-website-lead-form
            │
     ┌──────┴───────┐   (แตกขนานกัน — ฝั่งหนึ่งพังอีกฝั่งยังทำงาน)
     ▼              ▼
[ ส่งอีเมลคลินิก ]  [ แจ้ง LINE OA แอดมิน ]
 (Gmail node)       (Messaging API push)
```

> **สำคัญ:** อีเมล + LINE ทำ "ภายใน n8n" ไม่ใช่ที่ตัวฟอร์ม
> ตัวฟอร์มหน้าเว็บคุยกับ webhook อย่างเดียว (เบราว์เซอร์ส่งอีเมลเองไม่ได้อย่างน่าเชื่อถือ)
> → ข้อดี: ปลอดภัย (ไม่โผล่อีเมล/โทเคนในหน้าเว็บ), แก้ปลายทางทีหลังได้โดยไม่ต้องแตะฟอร์ม

---

## ✅ สถานะ: พร้อมใช้งาน — เหลือแค่ฝังฟอร์ม
หลังบ้านทำงานครบลูปแล้ว: ฟอร์ม → webhook (nexorcus) → เด้งเข้ากลุ่ม LINE "Website Lead"
+ สำเนาเข้าอีเมลคลินิก `smilescape.lead@gmail.com` (เก็บเป็น backup) — **ไม่ต้องตั้งค่า n8n เพิ่ม**

## ไฟล์
| ไฟล์ | ใช้ทำอะไร |
|------|-----------|
| `embed-snippet.html` | **ไฟล์สำหรับฝัง** — เปิดมา select all → copy → วางได้เลย |
| `smilescape-lead-form.html` | ไฟล์เต็ม (มี `<html>` ครบ) ไว้เปิดดู/ทดสอบในเบราว์เซอร์ |

---

## วิธีฝังบนเว็บ (WordPress / Elementor) — 3 ขั้น
1. เปิด `embed-snippet.html` → **Select All (⌘A) → Copy (⌘C)**
2. ใน Elementor ลากวิดเจ็ต **HTML** มาวางตรงตำแหน่งที่ต้องการ → **วาง (⌘V)** โค้ดลงไป
3. กด **Update** → เสร็จ ใช้งานได้ทันที
   - (ถ้าไม่ใช้ Elementor: วางในบล็อก **Custom HTML** ของ Gutenberg ก็ได้ผลเหมือนกัน)

CSS ทั้งหมด scope อยู่ใต้ `#smilescape-lead-form` → ไม่กวนสไตล์ของหน้าเว็บเดิม

### ตั้งค่าเล็กน้อย (ในส่วน `CONFIG` ท้าย `<script>`)
```js
var CONFIG = {
  webhookUrl: 'https://nexorcus.app.n8n.cloud/webhook/smilescape-website-lead-form',
  clinicPhone: '',   // ใส่เบอร์เพื่อแสดงปุ่ม "โทร" บนหน้าขอบคุณ/หน้า error เช่น '02-123-4567'
  lineUrl: '',       // ใส่ลิงก์ LINE เช่น 'https://lin.ee/xxxxxx'
  timeStart: 10, timeEnd: 20, slotMinutes: 30  // ช่วงเวลานัด (ปรับได้)
};
```
- แก้ลิงก์ **นโยบายความเป็นส่วนตัว (PDPA)** ในฟอร์ม: ค่าเริ่มต้นชี้ไป `/privacy-policy`

---

## โครงสร้าง JSON ที่ฟอร์มส่ง (ตรงกับตัวอย่างที่ให้มา)
```json
{
  "service": "บริการอื่น ๆ",
  "firstName": "ณัฐชัยา",
  "lastName": "ภู่ทอง",
  "phone": "0618209621",
  "email": "natchaya9838@gmail.com",
  "appointmentDate": "15/06/2026",
  "appointmentTime": "14:00",
  "branch": "สาขารัตนาธิเบศร์ (นนทบุรี · MRT สีม่วง รัตนาธิเบศร์)",
  "submissionId": "ss-mpvi0peq-dwk7sv",
  "consent": true,
  "pageUrl": "https://smilescapeclinic.com/...",
  "submittedAt": "2026-06-01T17:44:45.986Z"
}
```
ฟิลด์ `service`, `firstName`, `lastName`, `phone`, `appointmentDate`, `appointmentTime`, `branch`,
`submissionId` ตรงกับสเปกเดิม 100% — เพิ่มให้ 3 ฟิลด์:
- `consent` (true เสมอ — เก็บไว้เป็นหลักฐาน PDPA)
- `pageUrl` (มาจากหน้าไหน — มีประโยชน์ตอนมีหลายหน้า/แลนดิ้ง)
- `submittedAt` (เวลา ISO — ใช้กันเคสซ้ำคู่กับ `submissionId`)

> หมายเหตุ: `appointmentDate` เป็นรูปแบบ **DD/MM/YYYY** (เหมือนตัวอย่าง) ส่วน `submittedAt` เป็น UTC ISO

---

## ฝั่ง n8n (nexorcus.app.n8n.cloud) — ✅ ทำงานอยู่แล้ว ไม่ต้องแตะ
Workflow บน nexorcus รับ webhook + ส่งผลลัพธ์เรียบร้อยแล้ว (ทีม Nexorcus ดูแล):
- เด้งข้อความ lead เข้า **กลุ่ม LINE "Website Lead"** ✅
- ส่งสำเนาเข้าอีเมล **`smilescape.lead@gmail.com`** (เก็บเป็น backup) ✅
- ทดสอบยิงจริงจาก origin ภายนอกแล้ว — ตอบ **200 + CORS ใช้ได้** ไม่ต้องตั้งค่าเพิ่ม

> ถ้าวันหลังอยาก **ตัดอีเมลออก** ให้เหลือ LINE อย่างเดียว → แก้ใน workflow nexorcus
> (disable node ส่งอีเมล) — ส่วนนี้อยู่ฝั่ง Nexorcus ไม่ใช่ในไฟล์ฟอร์มนี้

---

## ทดสอบ (หลังฝัง)
- กรอกฟอร์มบนเว็บ → กด "ยืนยันการนัดหมาย" → เช็กว่าเด้งเข้ากลุ่ม LINE "Website Lead"
- ขึ้นหน้า "ได้รับข้อมูลแล้ว 🎉" = ส่งสำเร็จ

> ⚠️ ตอน verify ผมยิงทดสอบ 1 ครั้ง (ณัฐชัยา ภู่ทอง, Source ID `ss-mpvi0peq-dwk7sv`) — มีเข้ากลุ่ม LINE จริง 1 รายการ ลบทิ้งได้

---

## ปรับแต่งเพิ่ม (ออปชัน ไม่บังคับ)
- [ ] เบอร์โทร + ลิงก์ LINE ใน `CONFIG` → โชว์ปุ่มสำรองบนหน้าขอบคุณ/error
- [ ] เช็ครายการ "บริการ" / "สาขา" ในดรอปดาวน์ (แก้ใน `<select>` ของไฟล์)
- [ ] แก้ลิงก์ PDPA `/privacy-policy` ให้ตรงหน้าจริง
- [ ] หลังแก้ไฟล์ `smilescape-lead-form.html` → สร้าง snippet ใหม่:
      `awk '/EMBED:START =/{f=1} f{print} /EMBED:END =/{f=0}' smilescape-lead-form.html > embed-snippet.html`
