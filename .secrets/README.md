# .secrets/ — ไม่ commit ไฟล์ในโฟลเดอร์นี้

เกตทั้งหมดใน `eywa-protocol-spec/scripts/citation-gates/` ต้องใช้ service key ของ Supabase
เพื่ออ่านฐานข้อมูลที่ใช้ร่วมกันสามแบรนด์

สร้างไฟล์ `supabase.env` ในโฟลเดอร์นี้ หนึ่งบรรทัด:

```
SUPABASE_SERVICE_KEY=<คีย์>
```

ตัวหาคีย์จะไล่ตามลำดับนี้ (ดู `eywa_supabase.py`):

1. ตัวแปรสภาพแวดล้อม `SUPABASE_SERVICE_KEY` — ทางที่ CI ควรใช้
2. `EYWA_SECRETS_ENV` ชี้ไปที่ไฟล์ที่มีคีย์
3. `.secrets/supabase.env` ไล่ขึ้นจากไดเรกทอรีที่รันอยู่

`.secrets/` อยู่ใน `.gitignore` แล้ว · **อย่าพิมพ์คีย์ลง log อย่าส่งต่อในแชท และอย่า commit**
คีย์เป็นสิทธิ์ระดับ service — อ่านเขียนได้ทั้งฐานของทั้งสามแบรนด์

ตรวจว่าตั้งค่าถูกแล้ว:

```bash
cd web && npm run gates:verify && npm run check:citations
```
