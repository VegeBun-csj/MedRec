/*
Navicat MySQL Data Transfer

Source Server         : louise
Source Server Version : 50717
Source Host           : localhost:3306
Source Database       : bishe2

Target Server Type    : MYSQL
Target Server Version : 50717
File Encoding         : 65001

Date: 2020-04-16 15:48:30
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `hospital`
-- ----------------------------
DROP TABLE IF EXISTS `hospital`;
CREATE TABLE `hospital` (
  `hid` int(11) NOT NULL AUTO_INCREMENT,
  `hname` varchar(20) DEFAULT NULL,
  `husername` varchar(20) DEFAULT NULL,
  `hpassword` varchar(20) DEFAULT NULL,
  `hlevel` varchar(20) DEFAULT NULL,
  `haddress` varchar(50) DEFAULT NULL,
  `htelephone` varchar(20) DEFAULT NULL,
  `hdescription` varchar(400) DEFAULT NULL,
  `wid` int(11) DEFAULT NULL,
  PRIMARY KEY (`hid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of hospital
-- ----------------------------
INSERT INTO `hospital` VALUES ('1', '淮安市第一人民医院', 'h1', '123', '全国三甲', '淮安市淮阴区北京西路', '1232131', 'good', null);
INSERT INTO `hospital` VALUES ('2', '淮安市第二人民医院', 'h2', '123', '全国三甲', '淮安市清浦区淮海路', '43234234', '23', null);

-- ----------------------------
-- Table structure for `medicine`
-- ----------------------------
DROP TABLE IF EXISTS `medicine`;
CREATE TABLE `medicine` (
  `m_type` varchar(50) DEFAULT NULL,
  `hid` int(11) NOT NULL,
  `mid` int(11) NOT NULL AUTO_INCREMENT,
  `m_name` varchar(50) DEFAULT NULL,
  `m_num` int(11) DEFAULT NULL,
  `m_price` float DEFAULT NULL,
  `m_status` int(11) DEFAULT NULL,
  `m_picture` varchar(100) DEFAULT NULL,
  `m_gongneng` varchar(200) DEFAULT NULL,
  `m_guige` varchar(50) DEFAULT NULL,
  `m_yongfa` varchar(200) DEFAULT NULL,
  `m_buliangfanying` varchar(200) DEFAULT NULL,
  `m_youxiaoqi` varchar(200) DEFAULT NULL,
  `m_producerName` varchar(200) DEFAULT NULL,
  `m_producerAddress` varchar(200) DEFAULT NULL,
  `m_wenhao` varchar(100) DEFAULT NULL,
  `m_chengfen` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`mid`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of medicine
-- ----------------------------
INSERT INTO `medicine` VALUES ('感冒发烧', '1', '1', '999感冒灵', '22', '11.8', '1', 'ganmaoling.jpg', '解热镇痛。用于感冒引起的头痛，发热，鼻塞，流涕，咽痛。', '10g*9包/盒', '开水冲服，一次10克（1袋），一日3次。', '偶见皮疹、荨麻疹、药热及粒细胞减少；可见困倦、嗜睡、口渴、虚弱感；长期大量用药会导致肝肾功能异常。', '24个月', '华润三九医药股份有限公司委托华润三九（枣庄）药业有限公司', '山东枣庄高新技术产业开发区广润路99号', '国药准字Z44021940', '岗梅、三叉苦、金盏银盘、野菊花、薄荷油、咖啡因、马来酸氯苯那敏、对乙酰氨基酚。辅料为滑石粉。');
INSERT INTO `medicine` VALUES ('感冒发烧', '1', '2', '感康 复方氨酚烷胺片 12片', '12', '13.6', '1', 'anfenwanan.jpg', '适用于缓解普通感冒及流行性感冒引起的发热、头痛、四肢酸痛、打喷嚏、流鼻涕、鼻塞、咽喉痛等症状。', '12片/盒', '口服。成人，一次1片，一日2次。', '有时有轻度头晕，乏力，恶心，上腹不适，口干。食欲缺乏和皮疹等，可自行恢复。', '36个月', '吉林省吴太感康药业有限公司', '长春市经济技术开发区北海路1372号', '国药准字H22026193', '本品为复方制剂，每片含对乙酰氨基酚250毫克，盐酸金刚烷胺100毫克，人工牛黄10毫克，咖啡因15毫克，马来酸氯苯那敏2毫克。辅料为：淀粉、糖粉、硬脂酸镁。');
INSERT INTO `medicine` VALUES ('咳嗽', '1', '3', '咳特灵', '33', '15', '1', 'ketening.jpg', '镇咳，祛痰，平喘，消炎。用于咳喘及慢性支气管炎咳嗽。', '100片/瓶', '口服，一次3片，一日2次。', '可见困倦、嗜睡、口渴、虚弱感。', '24个月', '广州白云山制药股份有限公司', '广州市白云区同和街云祥路88号', '国药准字Z44022409', '小叶榕干浸膏、马来酸氯苯那敏。辅料为糊精、羧甲基淀粉钠、硬脂酸镁。');
INSERT INTO `medicine` VALUES ('咳嗽', '1', '4', '雪梨膏', '42', '25', '1', 'xueligao.jpg', '清肺热，润燥止咳。用于干咳，久咳。', '120g*1瓶/盒', '开水冲服，一次9～15克，一日2～3次', '尚不明确', '24个月', '湖北盛通药业有限公司', '湖北盛通药业有限公司', '国药准字Z42020146', '梨。辅料为砂糖，枸橼酸。');
INSERT INTO `medicine` VALUES ('支气管炎', '1', '5', '结核丸', '32', '14.3', '1', 'jiehewan.jpg', '滋阴降火，补肺止嗽。用于阴虚火旺引起的潮热盗汗，咳痰咳血，胸胁闷痛，骨蒸痨嗽，肺结核、骨结核。', '	每20丸重3.5g', '口服，一次3.5g，一日2次。骨结核患者每次用生鹿角15g煎汤服药。', '尚不明确', '24个月', '甘肃天水岐黄药业有限责任公司', '甘肃天水岐黄药业有限责任公司', '	国药准字Z20025187', '龟甲（醋制）、百部（蜜炙）、地黄、熟地黄、阿胶、鳖甲（醋制）、北沙参、白及、牡蛎、川贝母、熟大黄、蜂蜡等16味。');
INSERT INTO `medicine` VALUES ('支气管炎', '1', '6', '气管炎丸', '22', '10.3', '1', 'qiguanyan.jpg', '散寒镇咳,，祛痰定喘。用于外感风寒引起的气管发炎，肺热咳嗽，气促哮喘，喉中发痒，痰涎壅盛，胸膈满闷，老年痰喘。', '300粒/瓶', '口服，一次30粒，一日2次。', '尚不明确', '48个月', '北京同仁堂科技发展股份有限公司制药厂', '北京同仁堂科技发展股份有限公司制药厂', '	国药准字Z11020250', '麻黄，苦杏仁（去皮炒），石膏,甘草（蜜炙），前胡，白前，百部（蜜炙），紫菀，款冬花（蜜炙）， 蛤壳（煅）， 葶苈子，化橘红（盐水炙）桔梗，茯苓，半夏曲（炒），远志（去心炒焦），旋覆花，浮海石（煅），紫苏子（炒），党参，大枣，五味子（醋炙）， 桂枝（炒）， 薤白， 白芍（酒炙）， 桑叶，射干，黄芩，青黛，蒲公英。');
INSERT INTO `medicine` VALUES ('感冒发烧', '1', '7', '维C银翘片', '56', '8.1', '1', 'vcyingqiao.jpg', '疏风解表，清热解毒。用于外感风热所致的流行性感冒，症见发热、头痛、咳嗽、口干、咽喉疼痛。', '24片/盒', '口服，一次2片，一日3次。', '可见困惓、嗜睡、口渴、虚弱感；偶见皮疹、荨麻疹、药热及粒细胞减少，过敏性休克、重症多形红斑型药疹、大疱性表皮松懈症；长期大量用药会导致肝肾功能异常。', '24个月', '贵州百灵企业集团制药股份有限公司', '贵州百灵企业集团制药股份有限公司', '国药准字Z52020455', '山银花、连翘、荆芥、淡豆豉、淡竹叶、牛蒡子、 芦根、桔梗、甘草、马来酸氣苯那敏、对乙酰氨基酚、维生素C、薄荷素油。辅料为淀粉、倍他环、糊精、硬脂酸镁、蔗糖、滑石粉、明胶、柠檬黄、 亮蓝、虫白蜡。');
INSERT INTO `medicine` VALUES ('高血压', '1', '8', '奥美沙坦', '33', '34', '1', 'aomeishatan.jpg', '本品适用于高血压的治疗。', '20mg*7片/盒', '通常推荐起始剂量为20mg，每日一次。', '眩晕、腹痛、消化不良、', '36个月', '第一三共制药(上海)有限公司', '第一三共制药(上海)有限公司', '国药准字H20060371', '奥美沙坦酯。');
INSERT INTO `medicine` VALUES ('高血压', '1', '9', '苯磺酸左氨氯地平', '23', '23.5', '1', 'zuoanlu.jpg', '（1）高血压，（2）心绞痛。', '2.5mg*14粒/盒', '初始剂量为2.5mg，一日1次 ', '患者对本品能很好地耐受。', '36个月', '施慧达药业集团（吉林）有限公司', '施慧达药业集团（吉林）有限公司', '国药准字H19991083', '本品主要成份为苯磺酸左旋氨氯地平。化学名称：（S）-（－）-3-乙基-5-甲基-2-（2-氨基乙氧甲基）-4-（2-氯苯基）-1，4-二氢-6-甲基-3，5-吡啶二羧酸酯苯磺酸盐。');
INSERT INTO `medicine` VALUES ('关节炎', '1', '10', '万通筋骨片', '22', '23.1', '1', 'wantong.jpg', '祛风散寒，通络止痛。用于痹症，肩周炎，颈椎病，腰腿痛，肌肉关节疼痛，屈伸不利，以及风湿性关节炎、类风湿性关节炎见以上证候者。', '0.28g*24片/盒', '口服，一次 2 片，一日 2～3 次；或遵医嘱。', '尚未明确。', '24个月', '通化万通药业股份有限公司', '通化万通药业股份有限公司', '国药准字Z20025183', '制川乌、制草乌、马钱子（制）、淫羊藿、牛膝、羌活、贯众、黄柏、乌梢蛇、鹿茸、续断、乌梅、细辛、麻黄、桂枝、红花、刺五加、金银花、地龙、桑寄生、甘草、骨碎补（烫）、地枫皮、没药（制）、红参。');
INSERT INTO `medicine` VALUES ('关节炎', '1', '11', '同济堂 黑骨藤追风活络胶囊', '21', '60.9', '1', 'huoluo.jpg', '苗医：抬奥、抬蒙：僵见风，稿计凋嘎边蒙。\r\n中医：祛风除湿，通络止痛。用于风寒湿痹，肩臂腰腿疼痛。', '每粒装0.3克。', '口服，一次3粒，一日3次，2周为一疗程。', '尚不明确。', '30个月', '贵州国药集团同济堂制药有限公司', '贵州国药集团同济堂制药有限公司', '国药准字Z20025279', '青风藤、黑骨藤、追风伞。辅料为淀粉。');
INSERT INTO `medicine` VALUES ('胃痛', '1', '12', '999 气滞胃痛颗粒', '12', '32.1', '1', 'qizhiweitong.jpg', '舒肝理气，和胃止痛。用于肝郁气滞，胸痞胀满，胃脘疼痛。', '5g*9袋/盒', '开水冲服，一次5克，一日3次。', '尚不明确', '36个月', '辽宁华润本溪三药有限公司', '辽宁省本溪经济技术开发区医药园区', '国药准字Z21021552', '柴胡、延胡索（炙）、枳壳、香附（炙）、白芍、炙甘草。辅料为蔗糖和糊精。');
INSERT INTO `medicine` VALUES ('胃痛', '1', '13', '正道邦克 参芪健胃颗粒', '23', '12', '1', 'jianwei.jpg', '温中健脾，理气和胃。主治脾胃虚寒型胃脘胀痛，痞闷不适，喜热喜按，嗳气呃逆等症。', '16g*6袋/盒', '饭前开水冲服。一次16克，一日3次或遵医嘱。', '尚不明确', '36个月', '江苏中兴药业有限公司', '江苏省镇江市丹徒高新技术产业园', '国药准字Z32020662', '党参、当归、山楂、黄芪、茯苓、甘草、白术、桂枝、陈皮、紫苏梗、白芍、海螵蛸、土木香、蒲公英。');

-- ----------------------------
-- Table structure for `office`
-- ----------------------------
DROP TABLE IF EXISTS `office`;
CREATE TABLE `office` (
  `officeType` int(20) DEFAULT NULL,
  `officeId` int(11) NOT NULL AUTO_INCREMENT,
  `officeName` varchar(20) DEFAULT NULL,
  `hid` int(11) DEFAULT NULL,
  PRIMARY KEY (`officeId`),
  KEY `FK_Reference_3` (`hid`),
  CONSTRAINT `FK_Reference_3` FOREIGN KEY (`hid`) REFERENCES `hospital` (`hid`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of office
-- ----------------------------
INSERT INTO `office` VALUES ('0', '1', '心内科', null);
INSERT INTO `office` VALUES ('0', '2', '老年医学科', null);
INSERT INTO `office` VALUES ('0', '3', '呼吸科', null);
INSERT INTO `office` VALUES ('0', '4', '消化内科', null);
INSERT INTO `office` VALUES ('0', '5', '神经内科', null);
INSERT INTO `office` VALUES ('0', '6', '肾内科', null);
INSERT INTO `office` VALUES ('0', '7', '血液科', null);
INSERT INTO `office` VALUES ('0', '8', '免疫风湿科', null);
INSERT INTO `office` VALUES ('0', '9', '皮肤科', null);
INSERT INTO `office` VALUES ('0', '10', '儿科', null);
INSERT INTO `office` VALUES ('0', '11', '肿瘤内科', null);
INSERT INTO `office` VALUES ('0', '12', '内分泌科', null);
INSERT INTO `office` VALUES ('1', '13', '肠胃外科', null);
INSERT INTO `office` VALUES ('1', '14', '血管外科', null);
INSERT INTO `office` VALUES ('1', '15', '神经外科', null);
INSERT INTO `office` VALUES ('1', '16', '肛肠科', null);
INSERT INTO `office` VALUES ('1', '17', '泌尿外科', null);
INSERT INTO `office` VALUES ('1', '18', '产科', null);
INSERT INTO `office` VALUES ('1', '19', '妇科', null);
INSERT INTO `office` VALUES ('1', '20', '眼科', null);
INSERT INTO `office` VALUES ('1', '21', '骨科', null);
INSERT INTO `office` VALUES ('1', '22', '耳鼻喉科', null);
INSERT INTO `office` VALUES ('1', '23', '心胸外科', null);
INSERT INTO `office` VALUES ('1', '24', '烧伤整形科', null);

-- ----------------------------
-- Table structure for `orders`
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `pid` int(11) DEFAULT NULL,
  `order_date` varchar(50) DEFAULT NULL,
  `order_price` float(20,0) DEFAULT NULL,
  `order_count` int(11) DEFAULT NULL,
  `oid` int(11) NOT NULL AUTO_INCREMENT,
  `hid` int(11) DEFAULT NULL,
  PRIMARY KEY (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of orders
-- ----------------------------

-- ----------------------------
-- Table structure for `patient`
-- ----------------------------
DROP TABLE IF EXISTS `patient`;
CREATE TABLE `patient` (
  `pid` int(10) NOT NULL AUTO_INCREMENT,
  `pname` varchar(20) DEFAULT NULL,
  `pusername` varchar(20) DEFAULT NULL,
  `ppassword` varchar(20) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `sex` int(11) DEFAULT NULL,
  `telephone` int(11) DEFAULT NULL,
  `icd` int(20) DEFAULT NULL,
  `wid` int(11) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of patient
-- ----------------------------
INSERT INTO `patient` VALUES ('1', '贾雪磊', 'jxl', '123', '22', '0', '4444', '123214324', null);
INSERT INTO `patient` VALUES ('2', null, '12312', '12212', null, null, null, null, null);
INSERT INTO `patient` VALUES ('3', null, '32143', '21312', null, null, null, null, null);
INSERT INTO `patient` VALUES ('4', null, '534534', '23123', null, null, null, null, null);
INSERT INTO `patient` VALUES ('5', null, 'dsd', 'wwq', null, null, null, null, null);
INSERT INTO `patient` VALUES ('6', null, 'eqweqw', 'qweqw', null, null, null, null, null);
INSERT INTO `patient` VALUES ('7', null, 'dasdasd', 'asdasd', null, null, null, null, null);
INSERT INTO `patient` VALUES ('8', null, 'zzzz', 'zzz', null, null, null, null, null);
INSERT INTO `patient` VALUES ('9', null, 'adsdas', 'dasdasd', null, null, null, null, null);
INSERT INTO `patient` VALUES ('10', null, 'qweqweqw', 'wqeqwewqe', null, null, null, null, null);

-- ----------------------------
-- Table structure for `relationship`
-- ----------------------------
DROP TABLE IF EXISTS `relationship`;
CREATE TABLE `relationship` (
  `allergic` varchar(100) DEFAULT NULL,
  `rid` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `hid` int(11) DEFAULT NULL,
  `bdate` varchar(50) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `officeId` int(11) DEFAULT NULL,
  `symptomId` int(11) DEFAULT NULL,
  PRIMARY KEY (`rid`),
  KEY `FK_Reference_1` (`pid`),
  KEY `FK_Reference_2` (`hid`),
  KEY `FK_Reference_7` (`officeId`),
  CONSTRAINT `FK_Reference_1` FOREIGN KEY (`pid`) REFERENCES `patient` (`pid`),
  CONSTRAINT `FK_Reference_2` FOREIGN KEY (`hid`) REFERENCES `hospital` (`hid`),
  CONSTRAINT `FK_Reference_7` FOREIGN KEY (`officeId`) REFERENCES `office` (`officeId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of relationship
-- ----------------------------
INSERT INTO `relationship` VALUES ('', '1', '1', '1', '2020-04-02 14:16:52', '情况正常', '1', null);
INSERT INTO `relationship` VALUES ('', '2', '1', '1', '2020-04-03 06:53:08', '傻大姐暗杀教室大胜靠德', '1', null);
INSERT INTO `relationship` VALUES ('', '3', '1', '1', '2020-04-11 10:02:07', 'sdffsdf', '1', null);
INSERT INTO `relationship` VALUES ('', '4', '1', '1', '2020-04-11 10:10:46', 'dsffsdf', '1', null);

-- ----------------------------
-- Table structure for `symptom`
-- ----------------------------
DROP TABLE IF EXISTS `symptom`;
CREATE TABLE `symptom` (
  `symptomId` int(11) NOT NULL AUTO_INCREMENT,
  `symptomName` varchar(20) DEFAULT NULL,
  `officeId` int(11) DEFAULT NULL,
  `mid` int(11) DEFAULT NULL,
  `hid` int(11) DEFAULT NULL,
  PRIMARY KEY (`symptomId`),
  KEY `FK_Reference_4` (`officeId`),
  KEY `FK_Reference_6` (`mid`),
  CONSTRAINT `FK_Reference_4` FOREIGN KEY (`officeId`) REFERENCES `office` (`officeId`),
  CONSTRAINT `FK_Reference_6` FOREIGN KEY (`mid`) REFERENCES `medicine` (`mid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of symptom
-- ----------------------------

-- ----------------------------
-- Table structure for `wallet`
-- ----------------------------
DROP TABLE IF EXISTS `wallet`;
CREATE TABLE `wallet` (
  `yu_e` float(20,0) DEFAULT NULL,
  `wid` int(11) NOT NULL,
  PRIMARY KEY (`wid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of wallet
-- ----------------------------

-- ----------------------------
-- Table structure for `wishlist`
-- ----------------------------
DROP TABLE IF EXISTS `wishlist`;
CREATE TABLE `wishlist` (
  `wish_id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT NULL,
  `mid` int(11) DEFAULT NULL,
  PRIMARY KEY (`wish_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of wishlist
-- ----------------------------
INSERT INTO `wishlist` VALUES ('10', '1', '1');
