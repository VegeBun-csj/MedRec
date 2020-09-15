/*
 Navicat Premium Data Transfer

 Source Server         : medrec
 Source Server Type    : MySQL
 Source Server Version : 50730
 Source Host           : 192.168.162.139:3306
 Source Schema         : medrec

 Target Server Type    : MySQL
 Target Server Version : 50730
 File Encoding         : 65001

 Date: 20/06/2020 18:24:32
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for bingren
-- ----------------------------
DROP TABLE IF EXISTS `bingren`;
CREATE TABLE `bingren`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `symptoms` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `zhuyuan` int(11) NULL DEFAULT NULL,
  `tijian` int(11) NOT NULL DEFAULT 1,
  `diagnosis` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `shengao` int(11) NULL DEFAULT NULL,
  `tizhong` int(11) NULL DEFAULT NULL,
  `shuzhangya` int(11) NULL DEFAULT NULL,
  `shousuoya` int(11) NULL DEFAULT NULL,
  `xintiao` int(11) NULL DEFAULT NULL,
  `xuejian` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `waike` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `neike` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100000 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bingren
-- ----------------------------
INSERT INTO `bingren` VALUES (1, '欧阳修', '22', '123', 3, 1, '', NULL, NULL, NULL, NULL, NULL, NULL, '', '');
INSERT INTO `bingren` VALUES (2, '欧阳峰', '27', '肚子疼', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `bingren` VALUES (8, '欧阳修', '22', '', 2, 1, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `bingren` VALUES (99999, NULL, NULL, NULL, NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for hospital
-- ----------------------------
DROP TABLE IF EXISTS `hospital`;
CREATE TABLE `hospital`  (
  `hid` int(11) NOT NULL AUTO_INCREMENT,
  `hname` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `husername` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `hpassword` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `hlevel` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `haddress` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `htelephone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `hdescription` varchar(400) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `wid` int(11) NULL DEFAULT NULL,
  `userid` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`hid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hospital
-- ----------------------------
INSERT INTO `hospital` VALUES (1, '第一人民医院', 'h1', '123456', '全国三甲', '上海路28号', '1232131', 'good', NULL, 10002);
INSERT INTO `hospital` VALUES (2, '第二人民医院', 'h2', '123456', '全国三甲', '上海路29号', '1232131', 'good', NULL, 10003);

-- ----------------------------
-- Table structure for hospital_wallet
-- ----------------------------
DROP TABLE IF EXISTS `hospital_wallet`;
CREATE TABLE `hospital_wallet`  (
  `yu_e` float(22, 0) NULL DEFAULT NULL,
  `h_wid` int(11) NOT NULL AUTO_INCREMENT,
  `hid` int(11) NULL DEFAULT NULL,
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`h_wid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hospital_wallet
-- ----------------------------
INSERT INTO `hospital_wallet` VALUES (10070, 1, 1, '123');
INSERT INTO `hospital_wallet` VALUES (1166, 2, 2, '123');

-- ----------------------------
-- Table structure for inporders
-- ----------------------------
DROP TABLE IF EXISTS `inporders`;
CREATE TABLE `inporders`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `patient_id` int(11) NULL DEFAULT NULL,
  `item_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pinci` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `chuyuantongzhi` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `cost` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of inporders
-- ----------------------------
INSERT INTO `inporders` VALUES (6, 1, '多喝热水', '最好是开水', '每天八杯', '否', '执行中', 1111);

-- ----------------------------
-- Table structure for lunbo
-- ----------------------------
DROP TABLE IF EXISTS `lunbo`;
CREATE TABLE `lunbo`  (
  `lunbo_id` int(11) NOT NULL,
  `news_title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `news_date` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `news_content` varchar(10000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`lunbo_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lunbo
-- ----------------------------
INSERT INTO `lunbo` VALUES (1, '日本福冈一医院17名医务人员感染新冠肺炎\r\n', '2020-04-02 14:14:36', '<p>&nbsp;&nbsp;日本福冈一医院17名医务人员感染新冠肺炎【央视新闻客户端】</p>\r\n\r\n<br>\r\n\r\n&nbsp;&nbsp;1日，日本福冈县北九州市门司区的一所医院确认17名医护人员感染新冠肺炎，目前该医院暂时停止接收急救和外来患者。\r\n该医院于3月31日已被确认当地一名80多岁的男性感染新冠肺炎住院，4月1日确认医务人员感染，该医院认为发生集体感染的可能性很高。<br>\r\n\r\n&nbsp;&nbsp;目前，福冈县通过日本厚生劳动省请求派遣相关对策小组进行应对。北九州市决定对尚未接受新冠病毒检测的约600名医院职员和183名住院患者全部进行检查，但由于人数众多，已开始请求福冈县和福冈市的协助。<br>\r\n\r\n来源：央视新闻客户端');
INSERT INTO `lunbo` VALUES (2, '5月底疫苗可进行动物试验和有效性试验阶段', '2020-04-02 18:28:20', '<p>&nbsp;&nbsp;5月底疫苗可进行动物试验和有效性试验阶段</p><br>\r\n&nbsp;&nbsp;央视网消息：4月1日下午，在北京市新冠肺炎疫情防控工作新闻发布会上，相关负责人介绍，自3月24日以来，北京市已经连续8天无本地新增病例。北京市4月1日的新增境外输入病例数也为零。<br>&nbsp;&nbsp;北京市委宣传部副部长北京市人民政府新闻办室主任徐和建：3月31日0时至4月1日12时，北京己无新增报告境外输入新冠肺炎确诊病例，也无新增报告本地确诊病例，实现双零增长。<br>&nbsp;&nbsp;徐和建指出，目前北京仍然面临境外疫情输入风险和人员流动后疫情反弹风险的双重压力，要抓住当前的机遇窗口期，逐步恢复生产生活秩序。另外，北京市也专门成立了工作小组，对新冠病毒的疫苗、检测试剂等开展研发工作，其中，新冠病毒杀查一体空气消毒系统，快速杀灭新冠病毒的效果高于99.9%，近期将用于武汉对隔离病房的消毒，此外，新冠肺炎疫苗、抗体药物的研发也取得突破性进展。<br>&nbsp;&nbsp;清华大学科研院副院长邓宁：拥有自主知识产权病毒载体的腺病毒疫苗和mRNA单克隆抗体药物已成功分离出200余株具有高效中和能力的抗新冠病毒单克隆抗体及其编码基因，5月底疫苗和抗体药物均可进入动物安全性和有效性试验阶段。');
INSERT INTO `lunbo` VALUES (3, '南非顶尖艾滋病专家因新冠去世，享年64岁', '2020-04-02 18:28:20', '<p>&nbsp;&nbsp;南非顶尖艾滋病专家因新冠去世，享年64岁</p><br>&nbsp;&nbsp;3月31日，64岁南非顶尖艾滋病防治专家吉塔·蓝吉因新冠肺炎并发症去世。<br>&nbsp;&nbsp;3月中旬，她结束在英国的学术工作后返回南非，当时已出现感染症状。');
INSERT INTO `lunbo` VALUES (4, '钟南山谈后遗症：是否会有后遗症还需要密切观察', '2020-04-02 16:23:42', '<p>&nbsp;&nbsp;钟南山谈康复患者是否会有后遗症：还需要密切观察</p><br>&nbsp;&nbsp;从4月1日起，我国每日疫情通报中将公布无症状感染者的有关情况。据广东省报告，3月31日新增无症状感染者1例。截至3月31日24时，尚在医学观察无症状感染者50例，其中境外输入38例。<br>&nbsp;&nbsp;无症状感染者是否具有传染性？对此，国家卫健委高级别专家组组长、中国工程院院士钟南山接受媒体采访时表示，无症状患者有明确的传染性，已经得到了证实；但是否具有较强的传染性，现在没有证据说明。<br>');

-- ----------------------------
-- Table structure for medicine
-- ----------------------------
DROP TABLE IF EXISTS `medicine`;
CREATE TABLE `medicine`  (
  `m_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `hid` int(11) NOT NULL,
  `mid` int(11) NOT NULL AUTO_INCREMENT,
  `m_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `m_num` int(11) NULL DEFAULT NULL,
  `m_price` float NULL DEFAULT NULL,
  `m_status` int(11) NULL DEFAULT NULL,
  `m_picture` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `m_gongneng` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `m_guige` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `m_yongfa` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `m_buliangfanying` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `m_youxiaoqi` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `m_producerName` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `m_producerAddress` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `m_wenhao` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `m_chengfen` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`mid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medicine
-- ----------------------------
INSERT INTO `medicine` VALUES ('感冒发烧', 1, 1, '999感冒灵', 9, 11.8, 1, 'ganmaoling.jpg', '解热镇痛。用于感冒引起的头痛，发热，鼻塞，流涕，咽痛。', '10g*9包/盒', '开水冲服，一次10克（1袋），一日3次。', '偶见皮疹、荨麻疹、药热及粒细胞减少；可见困倦、嗜睡、口渴、虚弱感；长期大量用药会导致肝肾功能异常。', '24个月', '华润三九医药股份有限公司委托华润三九（枣庄）药业有限公司', '山东枣庄高新技术产业开发区广润路99号', '国药准字Z44021940', '岗梅、三叉苦、金盏银盘、野菊花、薄荷油、咖啡因、马来酸氯苯那敏、对乙酰氨基酚。辅料为滑石粉。');
INSERT INTO `medicine` VALUES ('感冒发烧', 1, 2, '感康 复方氨酚烷胺片 12片', 5, 13.6, 1, 'anfenwanan.jpg', '适用于缓解普通感冒及流行性感冒引起的发热、头痛、四肢酸痛、打喷嚏、流鼻涕、鼻塞、咽喉痛等症状。', '12片/盒', '口服。成人，一次1片，一日2次。', '有时有轻度头晕，乏力，恶心，上腹不适，口干。食欲缺乏和皮疹等，可自行恢复。', '36个月', '吉林省吴太感康药业有限公司', '长春市经济技术开发区北海路1372号', '国药准字H22026193', '本品为复方制剂，每片含对乙酰氨基酚250毫克，盐酸金刚烷胺100毫克，人工牛黄10毫克，咖啡因15毫克，马来酸氯苯那敏2毫克。辅料为：淀粉、糖粉、硬脂酸镁。');
INSERT INTO `medicine` VALUES ('咳嗽', 1, 3, '咳特灵', 28, 15, 1, 'ketening.jpg', '镇咳，祛痰，平喘，消炎。用于咳喘及慢性支气管炎咳嗽。', '100片/瓶', '口服，一次3片，一日2次。', '可见困倦、嗜睡、口渴、虚弱感。', '24个月', '广州白云山制药股份有限公司', '广州市白云区同和街云祥路88号', '国药准字Z44022409', '小叶榕干浸膏、马来酸氯苯那敏。辅料为糊精、羧甲基淀粉钠、硬脂酸镁。');
INSERT INTO `medicine` VALUES ('咳嗽', 1, 4, '雪梨膏', 39, 25, 1, 'xueligao.jpg', '清肺热，润燥止咳。用于干咳，久咳。', '120g*1瓶/盒', '开水冲服，一次9～15克，一日2～3次', '尚不明确', '24个月', '湖北盛通药业有限公司', '湖北盛通药业有限公司', '国药准字Z42020146', '梨。辅料为砂糖，枸橼酸。');
INSERT INTO `medicine` VALUES ('支气管炎', 1, 5, '结核丸', 32, 14.3, 1, 'jiehewan.jpg', '滋阴降火，补肺止嗽。用于阴虚火旺引起的潮热盗汗，咳痰咳血，胸胁闷痛，骨蒸痨嗽，肺结核、骨结核。', '	每20丸重3.5g', '口服，一次3.5g，一日2次。骨结核患者每次用生鹿角15g煎汤服药。', '尚不明确', '24个月', '甘肃天水岐黄药业有限责任公司', '甘肃天水岐黄药业有限责任公司', '	国药准字Z20025187', '龟甲（醋制）、百部（蜜炙）、地黄、熟地黄、阿胶、鳖甲（醋制）、北沙参、白及、牡蛎、川贝母、熟大黄、蜂蜡等16味。');
INSERT INTO `medicine` VALUES ('支气管炎', 1, 6, '气管炎丸', 20, 10.3, 1, 'qiguanyan.jpg', '散寒镇咳,，祛痰定喘。用于外感风寒引起的气管发炎，肺热咳嗽，气促哮喘，喉中发痒，痰涎壅盛，胸膈满闷，老年痰喘。', '300粒/瓶', '口服，一次30粒，一日2次。', '尚不明确', '48个月', '北京同仁堂科技发展股份有限公司制药厂', '北京同仁堂科技发展股份有限公司制药厂', '	国药准字Z11020250', '麻黄，苦杏仁（去皮炒），石膏,甘草（蜜炙），前胡，白前，百部（蜜炙），紫菀，款冬花（蜜炙）， 蛤壳（煅）， 葶苈子，化橘红（盐水炙）桔梗，茯苓，半夏曲（炒），远志（去心炒焦），旋覆花，浮海石（煅），紫苏子（炒），党参，大枣，五味子（醋炙）， 桂枝（炒）， 薤白， 白芍（酒炙）， 桑叶，射干，黄芩，青黛，蒲公英。');
INSERT INTO `medicine` VALUES ('感冒发烧', 1, 7, '维C银翘片', 56, 8.1, 1, 'vcyingqiao.jpg', '疏风解表，清热解毒。用于外感风热所致的流行性感冒，症见发热、头痛、咳嗽、口干、咽喉疼痛。', '24片/盒', '口服，一次2片，一日3次。', '可见困惓、嗜睡、口渴、虚弱感；偶见皮疹、荨麻疹、药热及粒细胞减少，过敏性休克、重症多形红斑型药疹、大疱性表皮松懈症；长期大量用药会导致肝肾功能异常。', '24个月', '贵州百灵企业集团制药股份有限公司', '贵州百灵企业集团制药股份有限公司', '国药准字Z52020455', '山银花、连翘、荆芥、淡豆豉、淡竹叶、牛蒡子、 芦根、桔梗、甘草、马来酸氣苯那敏、对乙酰氨基酚、维生素C、薄荷素油。辅料为淀粉、倍他环、糊精、硬脂酸镁、蔗糖、滑石粉、明胶、柠檬黄、 亮蓝、虫白蜡。');
INSERT INTO `medicine` VALUES ('高血压', 1, 8, '奥美沙坦', 33, 34, 1, 'aomeishatan.jpg', '本品适用于高血压的治疗。', '20mg*7片/盒', '通常推荐起始剂量为20mg，每日一次。', '眩晕、腹痛、消化不良、', '36个月', '第一三共制药(上海)有限公司', '第一三共制药(上海)有限公司', '国药准字H20060371', '奥美沙坦酯。');
INSERT INTO `medicine` VALUES ('高血压', 1, 9, '苯磺酸左氨氯地平', 19, 23.5, 1, 'zuoanlu.jpg', '（1）高血压，（2）心绞痛。', '2.5mg*14粒/盒', '初始剂量为2.5mg，一日1次 ', '患者对本品能很好地耐受。', '36个月', '施慧达药业集团（吉林）有限公司', '施慧达药业集团（吉林）有限公司', '国药准字H19991083', '本品主要成份为苯磺酸左旋氨氯地平。化学名称：（S）-（－）-3-乙基-5-甲基-2-（2-氨基乙氧甲基）-4-（2-氯苯基）-1，4-二氢-6-甲基-3，5-吡啶二羧酸酯苯磺酸盐。');
INSERT INTO `medicine` VALUES ('关节炎', 1, 10, '万通筋骨片', 22, 23.1, 1, 'wantong.jpg', '祛风散寒，通络止痛。用于痹症，肩周炎，颈椎病，腰腿痛，肌肉关节疼痛，屈伸不利，以及风湿性关节炎、类风湿性关节炎见以上证候者。', '0.28g*24片/盒', '口服，一次 2 片，一日 2～3 次；或遵医嘱。', '尚未明确。', '24个月', '通化万通药业股份有限公司', '通化万通药业股份有限公司', '国药准字Z20025183', '制川乌、制草乌、马钱子（制）、淫羊藿、牛膝、羌活、贯众、黄柏、乌梢蛇、鹿茸、续断、乌梅、细辛、麻黄、桂枝、红花、刺五加、金银花、地龙、桑寄生、甘草、骨碎补（烫）、地枫皮、没药（制）、红参。');
INSERT INTO `medicine` VALUES ('关节炎', 1, 11, '同济堂 黑骨藤追风活络胶囊', 21, 60.9, 1, 'huoluo.jpg', '苗医：抬奥、抬蒙：僵见风，稿计凋嘎边蒙。\r\n中医：祛风除湿，通络止痛。用于风寒湿痹，肩臂腰腿疼痛。', '每粒装0.3克。', '口服，一次3粒，一日3次，2周为一疗程。', '尚不明确。', '30个月', '贵州国药集团同济堂制药有限公司', '贵州国药集团同济堂制药有限公司', '国药准字Z20025279', '青风藤、黑骨藤、追风伞。辅料为淀粉。');
INSERT INTO `medicine` VALUES ('胃痛', 1, 12, '999 气滞胃痛颗粒', 12, 32.1, 1, 'qizhiweitong.jpg', '舒肝理气，和胃止痛。用于肝郁气滞，胸痞胀满，胃脘疼痛。', '5g*9袋/盒', '开水冲服，一次5克，一日3次。', '尚不明确', '36个月', '辽宁华润本溪三药有限公司', '辽宁省本溪经济技术开发区医药园区', '国药准字Z21021552', '柴胡、延胡索（炙）、枳壳、香附（炙）、白芍、炙甘草。辅料为蔗糖和糊精。');
INSERT INTO `medicine` VALUES ('胃痛', 1, 13, '正道邦克 参芪健胃颗粒', 17, 12, 1, 'jianwei.jpg', '温中健脾，理气和胃。主治脾胃虚寒型胃脘胀痛，痞闷不适，喜热喜按，嗳气呃逆等症。', '16g*6袋/盒', '饭前开水冲服。一次16克，一日3次或遵医嘱。', '尚不明确', '36个月', '江苏中兴药业有限公司', '江苏省镇江市丹徒高新技术产业园', '国药准字Z32020662', '党参、当归、山楂、黄芪、茯苓、甘草、白术、桂枝、陈皮、紫苏梗、白芍、海螵蛸、土木香、蒲公英。');
INSERT INTO `medicine` VALUES ('感冒发烧', 2, 14, '999感冒灵', 22, 11.8, 1, 'ganmaoling.jpg', '解热镇痛。用于感冒引起的头痛，发热，鼻塞，流涕，咽痛。', '10g*9包/盒', '开水冲服，一次10克（1袋），一日3次。', '偶见皮疹、荨麻疹、药热及粒细胞减少；可见困倦、嗜睡、口渴、虚弱感；长期大量用药会导致肝肾功能异常。', '24个月', '华润三九医药股份有限公司委托华润三九（枣庄）药业有限公司', '山东枣庄高新技术产业开发区广润路99号', '国药准字Z44021940', '岗梅、三叉苦、金盏银盘、野菊花、薄荷油、咖啡因、马来酸氯苯那敏、对乙酰氨基酚。辅料为滑石粉。');
INSERT INTO `medicine` VALUES ('感冒发烧', 2, 15, '感康 复方氨酚烷胺片 12片', 9, 13.6, 1, 'anfenwanan.jpg', '适用于缓解普通感冒及流行性感冒引起的发热、头痛、四肢酸痛、打喷嚏、流鼻涕、鼻塞、咽喉痛等症状。', '12片/盒', '口服。成人，一次1片，一日2次。', '有时有轻度头晕，乏力，恶心，上腹不适，口干。食欲缺乏和皮疹等，可自行恢复。', '36个月', '吉林省吴太感康药业有限公司', '长春市经济技术开发区北海路1372号', '国药准字H22026193', '本品为复方制剂，每片含对乙酰氨基酚250毫克，盐酸金刚烷胺100毫克，人工牛黄10毫克，咖啡因15毫克，马来酸氯苯那敏2毫克。辅料为：淀粉、糖粉、硬脂酸镁。');
INSERT INTO `medicine` VALUES ('咳嗽', 2, 16, '咳特灵', 30, 15, 1, 'ketening.jpg', '镇咳，祛痰，平喘，消炎。用于咳喘及慢性支气管炎咳嗽。', '100片/瓶', '口服，一次3片，一日2次。', '可见困倦、嗜睡、口渴、虚弱感。', '24个月', '广州白云山制药股份有限公司', '广州市白云区同和街云祥路88号', '国药准字Z44022409', '小叶榕干浸膏、马来酸氯苯那敏。辅料为糊精、羧甲基淀粉钠、硬脂酸镁。');
INSERT INTO `medicine` VALUES ('咳嗽', 2, 17, '雪梨膏', 40, 25, 1, 'xueligao.jpg', '清肺热，润燥止咳。用于干咳，久咳。', '120g*1瓶/盒', '开水冲服，一次9～15克，一日2～3次', '尚不明确', '24个月', '湖北盛通药业有限公司', '湖北盛通药业有限公司', '国药准字Z42020146', '梨。辅料为砂糖，枸橼酸。');
INSERT INTO `medicine` VALUES ('支气管炎', 2, 18, '结核丸', 32, 14.3, 1, 'jiehewan.jpg', '滋阴降火，补肺止嗽。用于阴虚火旺引起的潮热盗汗，咳痰咳血，胸胁闷痛，骨蒸痨嗽，肺结核、骨结核。', '	每20丸重3.5g', '口服，一次3.5g，一日2次。骨结核患者每次用生鹿角15g煎汤服药。', '尚不明确', '24个月', '甘肃天水岐黄药业有限责任公司', '甘肃天水岐黄药业有限责任公司', '	国药准字Z20025187', '龟甲（醋制）、百部（蜜炙）、地黄、熟地黄、阿胶、鳖甲（醋制）、北沙参、白及、牡蛎、川贝母、熟大黄、蜂蜡等16味。');
INSERT INTO `medicine` VALUES ('支气管炎', 2, 19, '气管炎丸', 22, 10.3, 1, 'qiguanyan.jpg', '散寒镇咳,，祛痰定喘。用于外感风寒引起的气管发炎，肺热咳嗽，气促哮喘，喉中发痒，痰涎壅盛，胸膈满闷，老年痰喘。', '300粒/瓶', '口服，一次30粒，一日2次。', '尚不明确', '48个月', '北京同仁堂科技发展股份有限公司制药厂', '北京同仁堂科技发展股份有限公司制药厂', '	国药准字Z11020250', '麻黄，苦杏仁（去皮炒），石膏,甘草（蜜炙），前胡，白前，百部（蜜炙），紫菀，款冬花（蜜炙）， 蛤壳（煅）， 葶苈子，化橘红（盐水炙）桔梗，茯苓，半夏曲（炒），远志（去心炒焦），旋覆花，浮海石（煅），紫苏子（炒），党参，大枣，五味子（醋炙）， 桂枝（炒）， 薤白， 白芍（酒炙）， 桑叶，射干，黄芩，青黛，蒲公英。');
INSERT INTO `medicine` VALUES ('感冒发烧', 2, 20, '维C银翘片', 56, 8.1, 1, 'vcyingqiao.jpg', '疏风解表，清热解毒。用于外感风热所致的流行性感冒，症见发热、头痛、咳嗽、口干、咽喉疼痛。', '24片/盒', '口服，一次2片，一日3次。', '可见困惓、嗜睡、口渴、虚弱感；偶见皮疹、荨麻疹、药热及粒细胞减少，过敏性休克、重症多形红斑型药疹、大疱性表皮松懈症；长期大量用药会导致肝肾功能异常。', '24个月', '贵州百灵企业集团制药股份有限公司', '贵州百灵企业集团制药股份有限公司', '国药准字Z52020455', '山银花、连翘、荆芥、淡豆豉、淡竹叶、牛蒡子、 芦根、桔梗、甘草、马来酸氣苯那敏、对乙酰氨基酚、维生素C、薄荷素油。辅料为淀粉、倍他环、糊精、硬脂酸镁、蔗糖、滑石粉、明胶、柠檬黄、 亮蓝、虫白蜡。');
INSERT INTO `medicine` VALUES ('高血压', 2, 21, '奥美沙坦', 33, 34, 1, 'aomeishatan.jpg', '本品适用于高血压的治疗。', '20mg*7片/盒', '通常推荐起始剂量为20mg，每日一次。', '眩晕、腹痛、消化不良、', '36个月', '第一三共制药(上海)有限公司', '第一三共制药(上海)有限公司', '国药准字H20060371', '奥美沙坦酯。');
INSERT INTO `medicine` VALUES ('高血压', 2, 22, '苯磺酸左氨氯地平', 19, 23.5, 1, 'zuoanlu.jpg', '（1）高血压，（2）心绞痛。', '2.5mg*14粒/盒', '初始剂量为2.5mg，一日1次 ', '患者对本品能很好地耐受。', '36个月', '施慧达药业集团（吉林）有限公司', '施慧达药业集团（吉林）有限公司', '国药准字H19991083', '本品主要成份为苯磺酸左旋氨氯地平。化学名称：（S）-（－）-3-乙基-5-甲基-2-（2-氨基乙氧甲基）-4-（2-氯苯基）-1，4-二氢-6-甲基-3，5-吡啶二羧酸酯苯磺酸盐。');
INSERT INTO `medicine` VALUES ('关节炎', 2, 23, '万通筋骨片', 22, 23.1, 1, 'wantong.jpg', '祛风散寒，通络止痛。用于痹症，肩周炎，颈椎病，腰腿痛，肌肉关节疼痛，屈伸不利，以及风湿性关节炎、类风湿性关节炎见以上证候者。', '0.28g*24片/盒', '口服，一次 2 片，一日 2～3 次；或遵医嘱。', '尚未明确。', '24个月', '通化万通药业股份有限公司', '通化万通药业股份有限公司', '国药准字Z20025183', '制川乌、制草乌、马钱子（制）、淫羊藿、牛膝、羌活、贯众、黄柏、乌梢蛇、鹿茸、续断、乌梅、细辛、麻黄、桂枝、红花、刺五加、金银花、地龙、桑寄生、甘草、骨碎补（烫）、地枫皮、没药（制）、红参。');
INSERT INTO `medicine` VALUES ('关节炎', 2, 24, '同济堂 黑骨藤追风活络胶囊', 21, 60.9, 1, 'huoluo.jpg', '苗医：抬奥、抬蒙：僵见风，稿计凋嘎边蒙。\r\n中医：祛风除湿，通络止痛。用于风寒湿痹，肩臂腰腿疼痛。', '每粒装0.3克。', '口服，一次3粒，一日3次，2周为一疗程。', '尚不明确。', '30个月', '贵州国药集团同济堂制药有限公司', '贵州国药集团同济堂制药有限公司', '国药准字Z20025279', '青风藤、黑骨藤、追风伞。辅料为淀粉。');
INSERT INTO `medicine` VALUES ('胃痛', 2, 25, '999 气滞胃痛颗粒', 12, 32.1, 1, 'qizhiweitong.jpg', '舒肝理气，和胃止痛。用于肝郁气滞，胸痞胀满，胃脘疼痛。', '5g*9袋/盒', '开水冲服，一次5克，一日3次。', '尚不明确', '36个月', '辽宁华润本溪三药有限公司', '辽宁省本溪经济技术开发区医药园区', '国药准字Z21021552', '柴胡、延胡索（炙）、枳壳、香附（炙）、白芍、炙甘草。辅料为蔗糖和糊精。');
INSERT INTO `medicine` VALUES ('胃痛', 2, 26, '正道邦克 参芪健胃颗粒', 18, 12, 1, 'jianwei.jpg', '温中健脾，理气和胃。主治脾胃虚寒型胃脘胀痛，痞闷不适，喜热喜按，嗳气呃逆等症。', '16g*6袋/盒', '饭前开水冲服。一次16克，一日3次或遵医嘱。', '尚不明确', '36个月', '江苏中兴药业有限公司', '江苏省镇江市丹徒高新技术产业园', '国药准字Z32020662', '党参、当归、山楂、黄芪、茯苓、甘草、白术、桂枝、陈皮、紫苏梗、白芍、海螵蛸、土木香、蒲公英。');
INSERT INTO `medicine` VALUES ('心内-心绞痛', 1, 27, '心绞痛丸', 222, 22, NULL, 'tmp-2-1590575913839', 'sadashjnaLSHIHAKn', '231312', 'asdjsnALHNSOANslANSLA', 'SADaSAscscxzc', '2022-1-1', 'hajshas', 'sadasjabsdjksa', 'sdsASAsAS', 'jkaJSKAdbAJDBAJD');

-- ----------------------------
-- Table structure for nurse
-- ----------------------------
DROP TABLE IF EXISTS `nurse`;
CREATE TABLE `nurse`  (
  `nid` int(6) UNSIGNED NOT NULL,
  `fname` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `mname` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `lname` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `bdate` date NOT NULL,
  `adate` date NOT NULL,
  `gender` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `sid` int(6) UNSIGNED NOT NULL,
  `assigned_ward` int(6) UNSIGNED NOT NULL,
  PRIMARY KEY (`nid`) USING BTREE,
  INDEX `sid`(`sid`) USING BTREE,
  CONSTRAINT `nurse_ibfk_1` FOREIGN KEY (`sid`) REFERENCES `nurse` (`nid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for office
-- ----------------------------
DROP TABLE IF EXISTS `office`;
CREATE TABLE `office`  (
  `officeType` int(20) NULL DEFAULT NULL,
  `officeId` int(11) NOT NULL AUTO_INCREMENT,
  `officeName` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `hid` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`officeId`) USING BTREE,
  INDEX `FK_Reference_3`(`hid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of office
-- ----------------------------
INSERT INTO `office` VALUES (0, 1, '心内科', NULL);
INSERT INTO `office` VALUES (0, 2, '老年医学科', NULL);
INSERT INTO `office` VALUES (0, 3, '呼吸科', NULL);
INSERT INTO `office` VALUES (0, 4, '消化内科', NULL);
INSERT INTO `office` VALUES (0, 5, '神经内科', NULL);
INSERT INTO `office` VALUES (0, 6, '肾内科', NULL);
INSERT INTO `office` VALUES (0, 7, '血液科', NULL);
INSERT INTO `office` VALUES (0, 8, '免疫风湿科', NULL);
INSERT INTO `office` VALUES (0, 9, '皮肤科', NULL);
INSERT INTO `office` VALUES (0, 10, '儿科', NULL);
INSERT INTO `office` VALUES (0, 11, '肿瘤内科', NULL);
INSERT INTO `office` VALUES (0, 12, '内分泌科', NULL);
INSERT INTO `office` VALUES (1, 13, '肠胃外科', NULL);
INSERT INTO `office` VALUES (1, 14, '血管外科', NULL);
INSERT INTO `office` VALUES (1, 15, '神经外科', NULL);
INSERT INTO `office` VALUES (1, 16, '肛肠科', NULL);
INSERT INTO `office` VALUES (1, 17, '泌尿外科', NULL);
INSERT INTO `office` VALUES (1, 18, '产科', NULL);
INSERT INTO `office` VALUES (1, 19, '妇科', NULL);
INSERT INTO `office` VALUES (1, 20, '眼科', NULL);
INSERT INTO `office` VALUES (1, 21, '骨科', NULL);
INSERT INTO `office` VALUES (1, 22, '耳鼻喉科', NULL);
INSERT INTO `office` VALUES (1, 23, '心胸外科', NULL);
INSERT INTO `office` VALUES (1, 24, '烧伤整形科', NULL);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `mid` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `order_date` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `order_price` float(20, 0) NOT NULL,
  `order_count` int(11) NOT NULL,
  `oid` int(11) NOT NULL AUTO_INCREMENT,
  `hid` int(11) NOT NULL,
  `order_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `order_status` int(11) NOT NULL,
  PRIMARY KEY (`oid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (10, 1, '2020-04-18 12:31:02', 69, 3, 9, 1, '9371F6032DA0', 1);
INSERT INTO `orders` VALUES (10, 1, '2020-04-18 12:45:13', 46, 2, 10, 1, '9A1B17FD179D', 1);
INSERT INTO `orders` VALUES (12, 1, '2020-04-18 12:46:59', 64, 2, 11, 1, '24190DA329F9', 1);
INSERT INTO `orders` VALUES (9, 1, '2020-04-18 12:48:04', 47, 2, 12, 1, 'CD5A017A809C', 1);
INSERT INTO `orders` VALUES (9, 1, '2020-04-18 12:49:05', 47, 2, 13, 1, '00B4AC5CFF29', 1);
INSERT INTO `orders` VALUES (13, 1, '2020-04-18 12:51:05', 24, 2, 14, 1, '0854FEDB724F', 1);
INSERT INTO `orders` VALUES (13, 1, '2020-04-18 12:51:22', 36, 3, 15, 1, '5EACEA35D6BF', 1);
INSERT INTO `orders` VALUES (2, 1, '2020-04-21 07:06:35', 27, 2, 16, 1, '6D0FBDE2A5D3', 2);
INSERT INTO `orders` VALUES (3, 1, '2020-04-21 07:08:39', 15, 1, 17, 1, '25F34F4F928F', 2);
INSERT INTO `orders` VALUES (4, 1, '2020-04-21 07:09:39', 25, 1, 18, 1, '958FB9153190', 2);
INSERT INTO `orders` VALUES (4, 1, '2020-04-21 07:10:17', 50, 2, 19, 1, '26793DDD1DAB', 1);
INSERT INTO `orders` VALUES (3, 1, '2020-04-24 05:09:21', 30, 2, 20, 1, 'E4CE6B160D6C', 2);
INSERT INTO `orders` VALUES (2, 1, '2020-04-25 10:46:59', 41, 3, 21, 1, 'E34295A6261B', 0);
INSERT INTO `orders` VALUES (1, 12, '2020-05-14 12:29:31', 130, 11, 22, 1, '6ACC3C4BDD94', 0);
INSERT INTO `orders` VALUES (2, 30, '2020-05-27 05:31:15', 27, 2, 23, 1, 'AE030E42E74D', 1);
INSERT INTO `orders` VALUES (3, 30, '2020-05-27 05:34:25', 45, 3, 24, 1, 'BA7E18DE12AB', 1);
INSERT INTO `orders` VALUES (3, 30, '2020-05-27 05:36:46', 30, 2, 25, 1, '425C23D695BC', 1);
INSERT INTO `orders` VALUES (1, 30, '2020-05-27 05:38:21', 12, 1, 26, 1, 'EC692CFE6178', 1);
INSERT INTO `orders` VALUES (13, 30, '2020-05-27 05:40:18', 12, 1, 27, 1, '58535199D7D6', 1);
INSERT INTO `orders` VALUES (16, 34, '2020-05-27 05:55:42', 45, 3, 28, 2, '8621F6545082', 1);
INSERT INTO `orders` VALUES (2, 4, '2020-05-28 13:10:28', 27, 2, 29, 1, '552F35680EB5', 0);
INSERT INTO `orders` VALUES (4, 7, '2020-05-31 05:08:56', 25, 1, 30, 1, 'F41BFFBC19A7', 1);
INSERT INTO `orders` VALUES (1, 15, '2020-06-03 07:29:57', 12, 1, 31, 1, '2AE9524D8B6F', 1);
INSERT INTO `orders` VALUES (3, 15, '2020-06-03 07:31:17', 30, 2, 32, 1, '85E81975AA49', 2);
INSERT INTO `orders` VALUES (6, 23, '2020-06-04 04:20:31', 21, 2, 33, 1, 'AE8A6AA5300B', 1);

-- ----------------------------
-- Table structure for patient
-- ----------------------------
DROP TABLE IF EXISTS `patient`;
CREATE TABLE `patient`  (
  `pid` int(10) NOT NULL AUTO_INCREMENT,
  `pname` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `pusername` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `ppassword` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `age` int(11) NULL DEFAULT NULL,
  `sex` int(11) NULL DEFAULT NULL,
  `telephone` int(11) NULL DEFAULT NULL,
  `icd` int(20) NULL DEFAULT NULL,
  `wid` int(11) NULL DEFAULT NULL,
  `hid` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`pid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of patient
-- ----------------------------
INSERT INTO `patient` VALUES (1, '张三', 'ppp', 'U2FsdGVkX1+SizuVXVRcKwFnhsdsK2vO4Mj270yuWok=', 22, 0, 1111, 2222, NULL, 1);

-- ----------------------------
-- Table structure for patient_wallet
-- ----------------------------
DROP TABLE IF EXISTS `patient_wallet`;
CREATE TABLE `patient_wallet`  (
  `yu_e` float(20, 0) NULL DEFAULT NULL,
  `p_wid` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `p_wallet_name` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`p_wid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of patient_wallet
-- ----------------------------
INSERT INTO `patient_wallet` VALUES (1086, 1, 7, '1234', 'ccc');
INSERT INTO `patient_wallet` VALUES (1099, 2, 15, '123', 'ddd');
INSERT INTO `patient_wallet` VALUES (1191, 3, 23, '1234', 'ouyangxiu');

-- ----------------------------
-- Table structure for pats_in_hospital
-- ----------------------------
DROP TABLE IF EXISTS `pats_in_hospital`;
CREATE TABLE `pats_in_hospital`  (
  `id` int(11) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `diagnosis` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `dept_code` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pats_in_hospital_copy
-- ----------------------------
DROP TABLE IF EXISTS `pats_in_hospital_copy`;
CREATE TABLE `pats_in_hospital_copy`  (
  `id` int(11) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `diagnosis` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `dept_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pats_in_hospital_copy
-- ----------------------------
INSERT INTO `pats_in_hospital_copy` VALUES (1, '欧阳修', '444', '产科');

-- ----------------------------
-- Table structure for pre_user
-- ----------------------------
DROP TABLE IF EXISTS `pre_user`;
CREATE TABLE `pre_user`  (
  `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` char(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `user_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10004 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pre_user
-- ----------------------------
INSERT INTO `pre_user` VALUES (10001, 'fahim', '123456', 'Staff');
INSERT INTO `pre_user` VALUES (10002, 'yindoc', '123456', 'Doctor');
INSERT INTO `pre_user` VALUES (10003, 'yinnur', '123456', 'Nurse');

-- ----------------------------
-- Table structure for relationship
-- ----------------------------
DROP TABLE IF EXISTS `relationship`;
CREATE TABLE `relationship`  (
  `allergic` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `rid` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `hid` int(11) NOT NULL,
  `bdate` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `description` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `officeId` int(11) NOT NULL,
  `symptomId` int(11) NULL DEFAULT NULL,
  `mid` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`rid`) USING BTREE,
  INDEX `FK_Reference_1`(`pid`) USING BTREE,
  INDEX `FK_Reference_2`(`hid`) USING BTREE,
  INDEX `FK_Reference_7`(`officeId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of relationship
-- ----------------------------
INSERT INTO `relationship` VALUES ('没有', 1, 5, 2, '2020-06-02 13:19:51', '胸口疼', 1, NULL, NULL);
INSERT INTO `relationship` VALUES ('青霉素过敏', 2, 8, 1, '2020-06-03 05:22:29', '胸口疼', 1, 1, NULL);
INSERT INTO `relationship` VALUES ('青霉素', 3, 15, 1, '2020-06-03 06:44:50', '胸口疼', 1, 1, NULL);
INSERT INTO `relationship` VALUES ('', 4, 17, 1, '2020-06-03 07:36:18', 'xiosjaks', 1, NULL, NULL);
INSERT INTO `relationship` VALUES ('青霉素过敏', 5, 21, 1, '2020-06-03 13:21:10', '胸口疼', 1, 1, NULL);
INSERT INTO `relationship` VALUES ('红霉素过敏', 6, 22, 2, '2020-06-03 13:32:31', '心悸', 1, 1, NULL);
INSERT INTO `relationship` VALUES ('对青霉素过敏', 7, 23, 1, '2020-06-04 03:57:02', '胸口疼', 1, 1, 27);
INSERT INTO `relationship` VALUES ('青霉素过敏', 8, 1, 1, '2020-06-04 06:21:23', '胸口疼', 1, 1, NULL);

-- ----------------------------
-- Table structure for symptom
-- ----------------------------
DROP TABLE IF EXISTS `symptom`;
CREATE TABLE `symptom`  (
  `symptomId` int(11) NOT NULL AUTO_INCREMENT,
  `symptomName` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `officeId` int(11) NULL DEFAULT NULL,
  `hid` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`symptomId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 73 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of symptom
-- ----------------------------
INSERT INTO `symptom` VALUES (1, '心内-心绞痛', 1, 1);
INSERT INTO `symptom` VALUES (2, '心内-心律失常', 1, 1);
INSERT INTO `symptom` VALUES (3, '心内-心力衰竭', 1, 1);
INSERT INTO `symptom` VALUES (4, '老年-动脉硬化', 2, 1);
INSERT INTO `symptom` VALUES (5, '老年-老年痴呆', 2, 1);
INSERT INTO `symptom` VALUES (6, '老年-视听障碍', 2, 1);
INSERT INTO `symptom` VALUES (7, '呼吸-上呼吸道感染', 3, 1);
INSERT INTO `symptom` VALUES (8, '呼吸-流感', 3, 1);
INSERT INTO `symptom` VALUES (9, '呼吸-支气管炎', 3, 1);
INSERT INTO `symptom` VALUES (10, '消化-食道炎', 4, 1);
INSERT INTO `symptom` VALUES (11, '消化-上消化道出血', 4, 1);
INSERT INTO `symptom` VALUES (12, '消化-胆囊炎', 4, 1);
INSERT INTO `symptom` VALUES (13, '神经（内）-面神经炎', 5, 1);
INSERT INTO `symptom` VALUES (14, '神经（内）-急性脊髓炎', 5, 1);
INSERT INTO `symptom` VALUES (15, '神经（内）-帕金森病', 5, 1);
INSERT INTO `symptom` VALUES (16, '肾内-肾功能不全', 6, 1);
INSERT INTO `symptom` VALUES (17, '肾内-肾功能衰竭', 6, 1);
INSERT INTO `symptom` VALUES (18, '肾内-肾小球肾炎', 6, 1);
INSERT INTO `symptom` VALUES (19, '血液-贫血症', 7, 1);
INSERT INTO `symptom` VALUES (20, '血液-淋巴瘤', 7, 1);
INSERT INTO `symptom` VALUES (21, '血液-血友病', 7, 1);
INSERT INTO `symptom` VALUES (22, '免疫风湿-类风湿关节炎', 8, 1);
INSERT INTO `symptom` VALUES (23, '免疫风湿-成人斯蒂尔病', 8, 1);
INSERT INTO `symptom` VALUES (24, '免疫风湿-强直性脊柱炎', 8, 1);
INSERT INTO `symptom` VALUES (25, '皮肤-皮肤过敏', 9, 1);
INSERT INTO `symptom` VALUES (26, '皮肤-皮炎', 9, 1);
INSERT INTO `symptom` VALUES (27, '皮肤-湿疹', 9, 1);
INSERT INTO `symptom` VALUES (28, '儿科-肺炎', 10, 1);
INSERT INTO `symptom` VALUES (29, '儿科-腹泻', 10, 1);
INSERT INTO `symptom` VALUES (30, '儿科-缺钙', 10, 1);
INSERT INTO `symptom` VALUES (31, '肿瘤-乳腺癌', 11, 1);
INSERT INTO `symptom` VALUES (32, '肿瘤-肺癌', 11, 1);
INSERT INTO `symptom` VALUES (33, '肿瘤-胃癌', 11, 1);
INSERT INTO `symptom` VALUES (34, '内分泌-甲亢', 12, 1);
INSERT INTO `symptom` VALUES (35, '内分泌-糖尿病', 12, 1);
INSERT INTO `symptom` VALUES (36, '内分泌-痛风', 12, 1);
INSERT INTO `symptom` VALUES (37, '肠胃-胃炎', 13, 1);
INSERT INTO `symptom` VALUES (38, '肠胃-肠道息肉', 13, 1);
INSERT INTO `symptom` VALUES (39, '肠胃-十二指肠溃疡', 13, 1);
INSERT INTO `symptom` VALUES (40, '血管-血栓', 14, 1);
INSERT INTO `symptom` VALUES (41, '血管-静脉炎', 14, 1);
INSERT INTO `symptom` VALUES (42, '血管-动脉粥样硬化', 14, 1);
INSERT INTO `symptom` VALUES (43, '神经（外）-开放性颅脑损伤', 15, 1);
INSERT INTO `symptom` VALUES (44, '神经（外）-闭合性颅脑损伤', 15, 1);
INSERT INTO `symptom` VALUES (45, '神经（外）-颅内肿瘤', 15, 1);
INSERT INTO `symptom` VALUES (46, '肛肠-痔疮', 16, 1);
INSERT INTO `symptom` VALUES (47, '肛肠-肛瘘', 16, 1);
INSERT INTO `symptom` VALUES (48, '肛肠-直肠炎', 16, 1);
INSERT INTO `symptom` VALUES (49, '泌尿-前列腺炎', 17, 1);
INSERT INTO `symptom` VALUES (50, '泌尿-尿道炎', 17, 1);
INSERT INTO `symptom` VALUES (51, '泌尿-结石', 17, 1);
INSERT INTO `symptom` VALUES (52, '产科-子宫内膜异位', 18, 1);
INSERT INTO `symptom` VALUES (53, '产科-妊娠高血压', 18, 1);
INSERT INTO `symptom` VALUES (54, '产科-妊娠糖尿病', 18, 1);
INSERT INTO `symptom` VALUES (55, '妇科-阴道炎', 19, 1);
INSERT INTO `symptom` VALUES (56, '妇科-卵巢囊肿', 19, 1);
INSERT INTO `symptom` VALUES (57, '妇科-宫颈糜烂', 19, 1);
INSERT INTO `symptom` VALUES (58, '眼科-干眼症', 20, 1);
INSERT INTO `symptom` VALUES (59, '眼科-结膜炎', 20, 1);
INSERT INTO `symptom` VALUES (60, '眼科-青光眼', 20, 1);
INSERT INTO `symptom` VALUES (61, '骨科-先天畸形', 21, 1);
INSERT INTO `symptom` VALUES (62, '骨科-骨结核', 21, 1);
INSERT INTO `symptom` VALUES (63, '骨科-骨折', 21, 1);
INSERT INTO `symptom` VALUES (64, '耳鼻喉-中耳炎', 22, 1);
INSERT INTO `symptom` VALUES (65, '耳鼻喉-鼻息肉', 22, 1);
INSERT INTO `symptom` VALUES (66, '耳鼻喉-腺样体肥大', 22, 1);
INSERT INTO `symptom` VALUES (67, '心胸-心功能不全', 23, 1);
INSERT INTO `symptom` VALUES (68, '心胸-冠心病', 23, 1);
INSERT INTO `symptom` VALUES (69, '心胸-心肌炎', 23, 1);
INSERT INTO `symptom` VALUES (70, '烧伤整形-烧/烫/冻伤', 24, 1);
INSERT INTO `symptom` VALUES (71, '烧伤整形-皮肤撕脱伤', 24, 1);
INSERT INTO `symptom` VALUES (72, '烧伤整形-整形美容', 24, 1);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` char(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `user_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10004 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (10002, '第一人民医院', '123456', 'hospital1');
INSERT INTO `user` VALUES (10003, '第二人民医院', '123456', 'hospital2');

-- ----------------------------
-- Table structure for wishlist
-- ----------------------------
DROP TABLE IF EXISTS `wishlist`;
CREATE TABLE `wishlist`  (
  `wish_id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NULL DEFAULT NULL,
  `mid` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`wish_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wishlist
-- ----------------------------
INSERT INTO `wishlist` VALUES (10, 1, 1);
INSERT INTO `wishlist` VALUES (11, 1, 2);
INSERT INTO `wishlist` VALUES (12, 1, 3);
INSERT INTO `wishlist` VALUES (13, 30, 3);
INSERT INTO `wishlist` VALUES (14, 34, 20);
INSERT INTO `wishlist` VALUES (15, 44, 1);
INSERT INTO `wishlist` VALUES (16, 7, 4);
INSERT INTO `wishlist` VALUES (17, 15, 1);
INSERT INTO `wishlist` VALUES (18, 23, 6);

-- ----------------------------
-- Triggers structure for table pre_user
-- ----------------------------
DROP TRIGGER IF EXISTS `user_type_check`;
delimiter ;;
CREATE TRIGGER `user_type_check` AFTER INSERT ON `pre_user` FOR EACH ROW BEGIN
	IF (NEW.user_type='Staff' OR NEW.user_type='Nurse' OR NEW.user_type='Doctor' OR NEW.user_type='Patient') THEN
    INSERT INTO user
   ( username,
     password,
     user_type)
   VALUES
   ( NEW.username,
     NEW.password,
     NEW.user_type );
     END IF;
     
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table user
-- ----------------------------
DROP TRIGGER IF EXISTS `delete_on_pre_user`;
delimiter ;;
CREATE TRIGGER `delete_on_pre_user` AFTER DELETE ON `user` FOR EACH ROW BEGIN
	DELETE from pre_user 
    WHERE pre_user.username = old.username;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table user
-- ----------------------------
DROP TRIGGER IF EXISTS `user_delete`;
delimiter ;;
CREATE TRIGGER `user_delete` AFTER DELETE ON `user` FOR EACH ROW BEGIN
    delete from patient where patient.pid = old.id;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
