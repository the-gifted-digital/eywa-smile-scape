// ⚠️ MOCK TEAM DATA — for homepage TeamRoster layout/mockup ONLY.
// License numbers, names, and specialties are FABRICATED for design.
// MUST be replaced with real data (web/src/data/doctors.json / Supabase) before
// indexing or launch. The homepage is currently noindex,follow.

export type Locale = 'th' | 'en' | 'zh-cn';

export interface MockDoctor {
  key: string;
  license: string;                       // "ท. 12345" (MOCK)
  photo: string;                         // /images/lp/doctor1.png | doctor-praew.png
  href: string;                          // "#" (full profile page = future work)
  name: Record<Locale, string>;
  specialty: Record<Locale, string>;
}

export const TEAM_MOCK: MockDoctor[] = [
  {
    key: 'dr-01',
    license: 'ท. 31247',
    photo: '/images/lp/doctor1.png',
    href: '#',
    name: {
      th: 'ทพ. ปกรณ์ ศรีสุข (หมอกร)',
      en: 'Dr. Pakorn Srisuk (Dr. Korn)',
      'zh-cn': '帕空·斯里苏克 医生',
    },
    specialty: {
      th: 'ทันตกรรมรากเทียม',
      en: 'Dental Implantology',
      'zh-cn': '种植牙科',
    },
  },
  {
    key: 'dr-02',
    license: 'ท. 44812',
    photo: '/images/lp/doctor-praew.png',
    href: '#',
    name: {
      th: 'ทพญ. ศุภิสรา วัฒนเกียรติคุณ (หมอแพรว)',
      en: 'Dr. Suphisara Watthanakiattikun (Dr. Praew)',
      'zh-cn': '苏皮莎拉·瓦塔纳基亚提坤 医生',
    },
    specialty: {
      th: 'ทันตกรรมจัดฟัน (คลินิกออร์โธ)',
      en: 'Orthodontics',
      'zh-cn': '正畸科',
    },
  },
  {
    key: 'dr-03',
    license: 'ท. 27563',
    photo: '/images/lp/doctor1.png',
    href: '#',
    name: {
      th: 'ทพ. วรินทร์ นิลรัตน์ (หมอวิน)',
      en: 'Dr. Warin Ninlarat (Dr. Win)',
      'zh-cn': '瓦林·尼拉特 医生',
    },
    specialty: {
      th: 'วิทยาเอ็นโดดอนต์ (รักษาราก)',
      en: 'Endodontics (Root Canal)',
      'zh-cn': '牙髓病学（根管治疗）',
    },
  },
  {
    key: 'dr-04',
    license: 'ท. 58934',
    photo: '/images/lp/doctor-praew.png',
    href: '#',
    name: {
      th: 'ทพญ. ณัฐธิดา อภิวัฒน์สกุล (หมอฝน)',
      en: 'Dr. Natthida Aphiwatthansakun (Dr. Fon)',
      'zh-cn': '纳蒂达·阿皮瓦塔纳萨坤 医生',
    },
    specialty: {
      th: 'ปริทันตวิทยา (เหงือกและกระดูกรองรับฟัน)',
      en: 'Periodontics (Gums & Supporting Bone)',
      'zh-cn': '牙周病学（牙龈与支撑骨骼）',
    },
  },
  {
    key: 'dr-05',
    license: 'ท. 39201',
    photo: '/images/lp/doctor1.png',
    href: '#',
    name: {
      th: 'ทพ. ชัยวัฒน์ ตั้งมั่น (หมอชัย)',
      en: 'Dr. Chaiwat Tangman (Dr. Chai)',
      'zh-cn': '柴瓦特·唐曼 医生',
    },
    specialty: {
      th: 'ศัลยศาสตร์ช่องปากและแม็กซิลโลเฟเชียล',
      en: 'Oral & Maxillofacial Surgery',
      'zh-cn': '口腔颌面外科',
    },
  },
  {
    key: 'dr-06',
    license: 'ท. 62417',
    photo: '/images/lp/doctor-praew.png',
    href: '#',
    name: {
      th: 'ทพญ. กนกวรรณ ใจดี (หมอแนน)',
      en: 'Dr. Kanokwan Jaidee (Dr. Nan)',
      'zh-cn': '卡诺万·杰迪 医生',
    },
    specialty: {
      th: 'ทันตกรรมประดิษฐ์ (ฟันปลอม)',
      en: 'Prosthodontics',
      'zh-cn': '修复牙科（假牙）',
    },
  },
  {
    key: 'dr-07',
    license: 'ท. 15389',
    photo: '/images/lp/doctor1.png',
    href: '#',
    name: {
      th: 'ทพ. สิทธิชัย บุญรอด (หมอสิทธิ์)',
      en: 'Dr. Sittichai Boonrod (Dr. Sit)',
      'zh-cn': '西提猜·蓬洛德 医生',
    },
    specialty: {
      th: 'ทันตกรรมสำหรับเด็ก (กุมารทันตแพทย์)',
      en: 'Pediatric Dentistry',
      'zh-cn': '儿童牙科',
    },
  },
  {
    key: 'dr-08',
    license: 'ท. 73526',
    photo: '/images/lp/doctor-praew.png',
    href: '#',
    name: {
      th: 'ทพญ. พิมพ์ชนก รุ่งเรือง (หมอพิม)',
      en: 'Dr. Phimchanok Rungruang (Dr. Pim)',
      'zh-cn': '皮姆查诺克·隆鲁昂 医生',
    },
    specialty: {
      th: 'ทันตกรรมเพื่อความงาม (วีเนียร์และฟอกสีฟัน)',
      en: 'Cosmetic Dentistry (Veneers & Whitening)',
      'zh-cn': '美容牙科（贴片与美白）',
    },
  },
  {
    key: 'dr-09',
    license: 'ท. 48762',
    photo: '/images/lp/doctor1.png',
    href: '#',
    name: {
      th: 'ทพ. ธนวัต สุวรรณโรจน์ (หมอโต)',
      en: 'Dr. Thanawat Suwannaroj (Dr. Toh)',
      'zh-cn': '塔那瓦特·苏瓦纳罗 医生',
    },
    specialty: {
      th: 'รากเทียมทั้งปาก All-on-X',
      en: 'Full-Arch Implants (All-on-X)',
      'zh-cn': '全口种植牙（All-on-X）',
    },
  },
  {
    key: 'dr-10',
    license: 'ท. 91045',
    photo: '/images/lp/doctor-praew.png',
    href: '#',
    name: {
      th: 'ทพญ. อารียา จันทรเสน (หมออ้อ)',
      en: 'Dr. Ariya Jantrasena (Dr. Ao)',
      'zh-cn': '阿里亚·贾特拉塞纳 医生',
    },
    specialty: {
      th: 'ทันตกรรมหัตถการและบูรณะ',
      en: 'Restorative & Operative Dentistry',
      'zh-cn': '修复与操作牙科',
    },
  },
  {
    key: 'dr-11',
    license: 'ท. 23684',
    photo: '/images/lp/doctor1.png',
    href: '#',
    name: {
      th: 'ทพ. ภูมิพัฒน์ อินทร์แก้ว (หมอภูมิ)',
      en: 'Dr. Phumiphat Inkaew (Dr. Poom)',
      'zh-cn': '普米帕特·因卡伊乌 医生',
    },
    specialty: {
      th: 'ทันตกรรมรากเทียม (ดิจิทัลเวิร์กโฟลว์)',
      en: 'Digital Implantology',
      'zh-cn': '数字化种植牙科',
    },
  },
  {
    key: 'dr-12',
    license: 'ท. 67193',
    photo: '/images/lp/doctor-praew.png',
    href: '#',
    name: {
      th: 'ทพญ. วรัญญา โกมลวิทย์ (หมอวา)',
      en: 'Dr. Waranya Komonwit (Dr. Wa)',
      'zh-cn': '瓦拉尼亚·科蒙威特 医生',
    },
    specialty: {
      th: 'วิทยาเอ็นโดดอนต์ (รักษารากด้วยไมโครสโคป)',
      en: 'Endodontics (Microscopic Root Canal)',
      'zh-cn': '牙髓病学（显微镜根管治疗）',
    },
  },
  {
    key: 'dr-13',
    license: 'ท. 34571',
    photo: '/images/lp/doctor1.png',
    href: '#',
    name: {
      th: 'ทพ. กิตติศักดิ์ ลิ้มสุวรรณ (หมอกิ๊ต)',
      en: 'Dr. Kittisak Limsuwat (Dr. Kitt)',
      'zh-cn': '吉提沙克·林苏瓦特 医生',
    },
    specialty: {
      th: 'ปริทันตวิทยา (ผ่าตัดเหงือก)',
      en: 'Periodontics (Gum Surgery)',
      'zh-cn': '牙周病学（牙龈手术）',
    },
  },
  {
    key: 'dr-14',
    license: 'ท. 82340',
    photo: '/images/lp/doctor-praew.png',
    href: '#',
    name: {
      th: 'ทพญ. เบญจมาศ ชาติรัมย์ (หมอเบญ)',
      en: 'Dr. Benjamas Chatram (Dr. Ben)',
      'zh-cn': '本佳玛斯·察特拉姆 医生',
    },
    specialty: {
      th: 'ทันตกรรมจัดฟันใสInvisalign®',
      en: 'Clear Aligner Orthodontics (Invisalign®)',
      'zh-cn': '隐形矫正牙科（Invisalign®）',
    },
  },
  {
    key: 'dr-15',
    license: 'ท. 56027',
    photo: '/images/lp/doctor1.png',
    href: '#',
    name: {
      th: 'ทพ. ณัฐวุฒิ แสงจันทร์ (หมอนัท)',
      en: 'Dr. Nattawut Saengchan (Dr. Nat)',
      'zh-cn': '纳塔武特·桑占 医生',
    },
    specialty: {
      th: 'ศัลยศาสตร์รากเทียมและกระดูก',
      en: 'Implant & Bone Surgery',
      'zh-cn': '种植牙与骨科手术',
    },
  },
  {
    key: 'dr-16',
    license: 'ท. 19438',
    photo: '/images/lp/doctor-praew.png',
    href: '#',
    name: {
      th: 'ทพญ. ทิพย์วรรณ อุดมโชค (หมอทิพย์)',
      en: 'Dr. Thipwan Udomchok (Dr. Tip)',
      'zh-cn': '提万·乌多姆乔克 医生',
    },
    specialty: {
      th: 'ทันตกรรมประดิษฐ์ (ครอบฟันและสะพานฟัน)',
      en: 'Prosthodontics (Crowns & Bridges)',
      'zh-cn': '修复牙科（牙冠与桥接）',
    },
  },
  {
    key: 'dr-17',
    license: 'ท. 74819',
    photo: '/images/lp/doctor1.png',
    href: '#',
    name: {
      th: 'ทพ. วิษณุ เพ็ชร์งาม (หมอวิษ)',
      en: 'Dr. Witsanu Phetngam (Dr. Wit)',
      'zh-cn': '威萨努·佩特噶姆 医生',
    },
    specialty: {
      th: 'ทันตกรรมสำหรับเด็ก (ทารกถึงวัยรุ่น)',
      en: 'Pediatric Dentistry (Infant to Teen)',
      'zh-cn': '儿童牙科（婴幼儿至青少年）',
    },
  },
  {
    key: 'dr-18',
    license: 'ท. 40256',
    photo: '/images/lp/doctor-praew.png',
    href: '#',
    name: {
      th: 'ทพญ. สุนันท์ ไชยมงคล (หมอนัน)',
      en: 'Dr. Sunan Chaimongkol (Dr. Nun)',
      'zh-cn': '苏南·柴蒙康 医生',
    },
    specialty: {
      th: 'ทันตกรรมเพื่อความงาม (วีเนียร์พอร์ซเลน)',
      en: 'Cosmetic Dentistry (Porcelain Veneers)',
      'zh-cn': '美容牙科（瓷贴面）',
    },
  },
  {
    key: 'dr-19',
    license: 'ท. 63904',
    photo: '/images/lp/doctor1.png',
    href: '#',
    name: {
      th: 'ทพ. ประสิทธิ์ นวลจันทร์ (หมอสิทธิ์)',
      en: 'Dr. Prasit Nuanchan (Dr. Sit)',
      'zh-cn': '普拉西特·努安占 医生',
    },
    specialty: {
      th: 'รากเทียมทั้งปาก All-on-4 / All-on-6',
      en: 'Full-Arch Implants All-on-4 / All-on-6',
      'zh-cn': '全口种植牙 All-on-4 / All-on-6',
    },
  },
  {
    key: 'dr-20',
    license: 'ท. 87531',
    photo: '/images/lp/doctor-praew.png',
    href: '#',
    name: {
      th: 'ทพญ. อัจฉริยา เหลืองอ่อน (หมออ๋อ)',
      en: 'Dr. Atchariya Lueangon (Dr. Ao)',
      'zh-cn': '阿恰里亚·拉昂翁 医生',
    },
    specialty: {
      th: 'ทันตกรรมหัตถการ (อุดฟันและบูรณะสีเนื้อ)',
      en: 'Operative Dentistry (Tooth-Coloured Fillings)',
      'zh-cn': '修复牙科（树脂填充与仿色修复）',
    },
  },
];
