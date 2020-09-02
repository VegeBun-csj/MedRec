/*
Navicat MySQL Data Transfer

Source Server         : mysql
Source Server Version : 50717
Source Host           : localhost:3306
Source Database       : hospital_db

Target Server Type    : MYSQL
Target Server Version : 50717
File Encoding         : 65001

Date: 2020-05-09 14:32:39
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `bill`
-- ----------------------------
DROP TABLE IF EXISTS `bill`;
CREATE TABLE `bill` (
  `id` int(6) unsigned NOT NULL,
  `total_payable` int(40) DEFAULT NULL,
  `paid` int(20) DEFAULT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bill
-- ----------------------------
INSERT INTO `bill` VALUES ('1', null, null);

-- ----------------------------
-- Table structure for `bingren`
-- ----------------------------
DROP TABLE IF EXISTS `bingren`;
CREATE TABLE `bingren` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `symptoms` varchar(200) DEFAULT NULL,
  `tijian` int(11) NOT NULL DEFAULT '1',
  `diagnosis` varchar(200) DEFAULT NULL,
  `shengao` int(11) DEFAULT NULL,
  `tizhong` int(11) DEFAULT NULL,
  `shuzhangya` int(11) DEFAULT NULL,
  `shousuoya` int(11) DEFAULT NULL,
  `xintiao` int(11) DEFAULT NULL,
  `xuejian` varchar(200) DEFAULT NULL,
  `waike` varchar(200) DEFAULT NULL,
  `neike` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of bingren
-- ----------------------------
INSERT INTO `bingren` VALUES ('1', '贾雪磊', '22', '123', '1', '', '166', '22', '322', '222', '111', '正常', '非常正常', '正常');
INSERT INTO `bingren` VALUES ('2', '尹文睿', '27', '正常', '1', null, null, null, null, null, null, null, null, null);

-- ----------------------------
-- Table structure for `department`
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department` (
  `departmentid` int(11) NOT NULL,
  `departmentname` varchar(50) DEFAULT NULL,
  `hospitalid` int(11) NOT NULL,
  PRIMARY KEY (`departmentid`),
  KEY `hospitalid` (`hospitalid`),
  CONSTRAINT `hospitalid` FOREIGN KEY (`hospitalid`) REFERENCES `hospital` (`hospitalid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of department
-- ----------------------------

-- ----------------------------
-- Table structure for `doctor`
-- ----------------------------
DROP TABLE IF EXISTS `doctor`;
CREATE TABLE `doctor` (
  `did` int(6) unsigned NOT NULL,
  `fname` varchar(20) NOT NULL,
  `mname` varchar(20) DEFAULT NULL,
  `lname` varchar(20) NOT NULL,
  `bdate` date NOT NULL,
  `adate` date NOT NULL,
  `gender` varchar(20) NOT NULL,
  `rid` int(6) unsigned NOT NULL,
  `assigned_ward` int(6) unsigned NOT NULL,
  PRIMARY KEY (`did`),
  KEY `rid` (`rid`),
  CONSTRAINT `doctor_ibfk_1` FOREIGN KEY (`rid`) REFERENCES `doctor` (`did`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of doctor
-- ----------------------------

-- ----------------------------
-- Table structure for `education_qualification`
-- ----------------------------
DROP TABLE IF EXISTS `education_qualification`;
CREATE TABLE `education_qualification` (
  `did` int(6) unsigned NOT NULL,
  `degree` varchar(20) NOT NULL,
  `board` varchar(20) NOT NULL,
  `year` varchar(20) NOT NULL,
  `cgpa` varchar(20) NOT NULL,
  `position` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of education_qualification
-- ----------------------------
INSERT INTO `education_qualification` VALUES ('10002', 'testdegree', 'testboard', 'testyear', 'testdivision', 'testposition');
INSERT INTO `education_qualification` VALUES ('10002', '', '', '', '', '');
INSERT INTO `education_qualification` VALUES ('10002', '', '', '', '', '');
INSERT INTO `education_qualification` VALUES ('10002', '', '', '', '', '');
INSERT INTO `education_qualification` VALUES ('10002', '', '', '', '', '');
INSERT INTO `education_qualification` VALUES ('10003', 'testdegree', 'testboard', 'testyear', 'testdivision', 'testposition');
INSERT INTO `education_qualification` VALUES ('10003', '', '', '', '', '');
INSERT INTO `education_qualification` VALUES ('10003', '', '', '', '', '');
INSERT INTO `education_qualification` VALUES ('10003', '', '', '', '', '');
INSERT INTO `education_qualification` VALUES ('10003', '', '', '', '', '');

-- ----------------------------
-- Table structure for `experience`
-- ----------------------------
DROP TABLE IF EXISTS `experience`;
CREATE TABLE `experience` (
  `did` int(6) unsigned NOT NULL,
  `title` varchar(20) NOT NULL,
  `dfrom` date DEFAULT NULL,
  `dto` date DEFAULT NULL,
  `organization` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of experience
-- ----------------------------
INSERT INTO `experience` VALUES ('10002', 'testjob', '2015-03-14', '2017-03-14', 'testorg');
INSERT INTO `experience` VALUES ('10003', 'testjob', '2018-03-14', '2019-04-14', 'testorg');

-- ----------------------------
-- Table structure for `hospital`
-- ----------------------------
DROP TABLE IF EXISTS `hospital`;
CREATE TABLE `hospital` (
  `hospitalid` int(11) NOT NULL,
  `hospitalname` varchar(50) DEFAULT NULL,
  `hospitalpassword` varchar(50) DEFAULT NULL,
  `hospitallevel` int(11) DEFAULT NULL,
  `hospitaladdress` varchar(50) DEFAULT NULL,
  `hospitaltelephonenumber` int(50) DEFAULT NULL,
  `hospitalintroduction` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`hospitalid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of hospital
-- ----------------------------

-- ----------------------------
-- Table structure for `medicine`
-- ----------------------------
DROP TABLE IF EXISTS `medicine`;
CREATE TABLE `medicine` (
  `mid` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `type` varchar(20) NOT NULL,
  `u_price` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `mdate` date NOT NULL,
  `edate` date NOT NULL,
  PRIMARY KEY (`mid`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of medicine
-- ----------------------------

-- ----------------------------
-- Table structure for `medicinelist`
-- ----------------------------
DROP TABLE IF EXISTS `medicinelist`;
CREATE TABLE `medicinelist` (
  `medicinelistid` int(11) NOT NULL,
  `medicinename` varchar(50) DEFAULT NULL,
  `medicineamount` int(11) DEFAULT NULL,
  `medicineprice` float(11,0) DEFAULT NULL,
  PRIMARY KEY (`medicinelistid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of medicinelist
-- ----------------------------

-- ----------------------------
-- Table structure for `nurse`
-- ----------------------------
DROP TABLE IF EXISTS `nurse`;
CREATE TABLE `nurse` (
  `nid` int(6) unsigned NOT NULL,
  `fname` varchar(20) NOT NULL,
  `mname` varchar(20) DEFAULT NULL,
  `lname` varchar(20) NOT NULL,
  `bdate` date NOT NULL,
  `adate` date NOT NULL,
  `gender` varchar(20) NOT NULL,
  `sid` int(6) unsigned NOT NULL,
  `assigned_ward` int(6) unsigned NOT NULL,
  PRIMARY KEY (`nid`),
  KEY `sid` (`sid`),
  CONSTRAINT `nurse_ibfk_1` FOREIGN KEY (`sid`) REFERENCES `nurse` (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of nurse
-- ----------------------------

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
  KEY `FK_Reference_3` (`hid`)
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
-- Table structure for `patient2`
-- ----------------------------
DROP TABLE IF EXISTS `patient2`;
CREATE TABLE `patient2` (
  `patientid` int(11) NOT NULL AUTO_INCREMENT,
  `patientname` varchar(20) DEFAULT NULL,
  `patientusername` varchar(20) DEFAULT NULL,
  `patientpassword` varchar(20) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `phonenumber` int(20) DEFAULT NULL,
  `idcard` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`patientid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of patient2
-- ----------------------------

-- ----------------------------
-- Table structure for `pre_user`
-- ----------------------------
DROP TABLE IF EXISTS `pre_user`;
CREATE TABLE `pre_user` (
  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` char(60) NOT NULL,
  `user_type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10006 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pre_user
-- ----------------------------
INSERT INTO `pre_user` VALUES ('10001', 'fahim', '123456', 'Staff');
INSERT INTO `pre_user` VALUES ('10002', 'yindoc', '123456', 'Doctor');
INSERT INTO `pre_user` VALUES ('10003', 'yinnur', '123456', 'Nurse');
INSERT INTO `pre_user` VALUES ('10004', 'yinpatient', 'yin123', 'Patient');
INSERT INTO `pre_user` VALUES ('10005', 'yindoc2', '123456', 'Doctor');

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
  KEY `FK_Reference_7` (`officeId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of relationship
-- ----------------------------
INSERT INTO `relationship` VALUES ('', '1', '1', '1', '2020-04-02 14:16:52', '情况正常', '1', '2');
INSERT INTO `relationship` VALUES ('', '2', '1', '1', '2020-04-03 06:53:08', '傻大姐暗杀教室大胜靠德', '1', '1');
INSERT INTO `relationship` VALUES ('', '3', '1', '1', '2020-04-11 10:02:07', 'sdffsdf', '2', '6');
INSERT INTO `relationship` VALUES ('', '4', '1', '1', '2020-04-11 10:10:46', 'dsffsdf', '1', null);

-- ----------------------------
-- Table structure for `relationshipid`
-- ----------------------------
DROP TABLE IF EXISTS `relationshipid`;
CREATE TABLE `relationshipid` (
  `relationshipid` int(11) NOT NULL,
  `patientid` int(11) NOT NULL,
  `hospitalid` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `departmentid` int(11) DEFAULT NULL,
  `allergy` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`relationshipid`),
  KEY `patientid` (`patientid`),
  KEY `relationshiphospitalid` (`hospitalid`),
  KEY `departmentid` (`departmentid`),
  CONSTRAINT `departmentid` FOREIGN KEY (`departmentid`) REFERENCES `department` (`departmentid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `patientid` FOREIGN KEY (`patientid`) REFERENCES `patient2` (`patientid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `relationshiphospitalid` FOREIGN KEY (`hospitalid`) REFERENCES `hospital` (`hospitalid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of relationshipid
-- ----------------------------

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
  PRIMARY KEY (`symptomId`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of symptom
-- ----------------------------
INSERT INTO `symptom` VALUES ('1', '心内-心绞痛', '1', null, '1');
INSERT INTO `symptom` VALUES ('2', '心内-心律失常', '1', null, '1');
INSERT INTO `symptom` VALUES ('3', '心内-心力衰竭', '1', null, '1');
INSERT INTO `symptom` VALUES ('4', '老年-动脉硬化', '2', null, '1');
INSERT INTO `symptom` VALUES ('5', '老年-老年痴呆', '2', null, '1');
INSERT INTO `symptom` VALUES ('6', '老年-视听障碍', '2', null, '1');
INSERT INTO `symptom` VALUES ('7', '呼吸-上呼吸道感染', '3', null, '1');
INSERT INTO `symptom` VALUES ('8', '呼吸-流感', '3', null, '1');
INSERT INTO `symptom` VALUES ('9', '呼吸-支气管炎', '3', null, '1');
INSERT INTO `symptom` VALUES ('10', '消化-食道炎', '4', null, '1');
INSERT INTO `symptom` VALUES ('11', '消化-上消化道出血', '4', null, '1');
INSERT INTO `symptom` VALUES ('12', '消化-胆囊炎', '4', null, '1');
INSERT INTO `symptom` VALUES ('13', '神经（内）-面神经炎', '5', null, '1');
INSERT INTO `symptom` VALUES ('14', '神经（内）-急性脊髓炎', '5', null, '1');
INSERT INTO `symptom` VALUES ('15', '神经（内）-帕金森病', '5', null, '1');
INSERT INTO `symptom` VALUES ('16', '肾内-肾功能不全', '6', null, '1');
INSERT INTO `symptom` VALUES ('17', '肾内-肾功能衰竭', '6', null, '1');
INSERT INTO `symptom` VALUES ('18', '肾内-肾小球肾炎', '6', null, '1');
INSERT INTO `symptom` VALUES ('19', '血液-贫血症', '7', null, '1');
INSERT INTO `symptom` VALUES ('20', '血液-淋巴瘤', '7', null, '1');
INSERT INTO `symptom` VALUES ('21', '血液-血友病', '7', null, '1');
INSERT INTO `symptom` VALUES ('22', '免疫风湿-类风湿关节炎', '8', null, '1');
INSERT INTO `symptom` VALUES ('23', '免疫风湿-成人斯蒂尔病', '8', null, '1');
INSERT INTO `symptom` VALUES ('24', '免疫风湿-强直性脊柱炎', '8', null, '1');
INSERT INTO `symptom` VALUES ('25', '皮肤-皮肤过敏', '9', null, '1');
INSERT INTO `symptom` VALUES ('26', '皮肤-皮炎', '9', null, '1');
INSERT INTO `symptom` VALUES ('27', '皮肤-湿疹', '9', null, '1');
INSERT INTO `symptom` VALUES ('28', '儿科-肺炎', '10', null, '1');
INSERT INTO `symptom` VALUES ('29', '儿科-腹泻', '10', null, '1');
INSERT INTO `symptom` VALUES ('30', '儿科-缺钙', '10', null, '1');
INSERT INTO `symptom` VALUES ('31', '肿瘤-乳腺癌', '11', null, '1');
INSERT INTO `symptom` VALUES ('32', '肿瘤-肺癌', '11', null, '1');
INSERT INTO `symptom` VALUES ('33', '肿瘤-胃癌', '11', null, '1');
INSERT INTO `symptom` VALUES ('34', '内分泌-甲亢', '12', null, '1');
INSERT INTO `symptom` VALUES ('35', '内分泌-糖尿病', '12', null, '1');
INSERT INTO `symptom` VALUES ('36', '内分泌-痛风', '12', null, '1');
INSERT INTO `symptom` VALUES ('37', '肠胃-胃炎', '13', null, '1');
INSERT INTO `symptom` VALUES ('38', '肠胃-肠道息肉', '13', null, '1');
INSERT INTO `symptom` VALUES ('39', '肠胃-十二指肠溃疡', '13', null, '1');
INSERT INTO `symptom` VALUES ('40', '血管-血栓', '14', null, '1');
INSERT INTO `symptom` VALUES ('41', '血管-静脉炎', '14', null, '1');
INSERT INTO `symptom` VALUES ('42', '血管-动脉粥样硬化', '14', null, '1');
INSERT INTO `symptom` VALUES ('43', '神经（外）-开放性颅脑损伤', '15', null, '1');
INSERT INTO `symptom` VALUES ('44', '神经（外）-闭合性颅脑损伤', '15', null, '1');
INSERT INTO `symptom` VALUES ('45', '神经（外）-颅内肿瘤', '15', null, '1');
INSERT INTO `symptom` VALUES ('46', '肛肠-痔疮', '16', null, '1');
INSERT INTO `symptom` VALUES ('47', '肛肠-肛瘘', '16', null, '1');
INSERT INTO `symptom` VALUES ('48', '肛肠-直肠炎', '16', null, '1');
INSERT INTO `symptom` VALUES ('49', '泌尿-前列腺炎', '17', null, '1');
INSERT INTO `symptom` VALUES ('50', '泌尿-尿道炎', '17', null, '1');
INSERT INTO `symptom` VALUES ('51', '泌尿-结石', '17', null, '1');
INSERT INTO `symptom` VALUES ('52', '产科-子宫内膜异位', '18', null, '1');
INSERT INTO `symptom` VALUES ('53', '产科-妊娠高血压', '18', null, '1');
INSERT INTO `symptom` VALUES ('54', '产科-妊娠糖尿病', '18', null, '1');
INSERT INTO `symptom` VALUES ('55', '妇科-阴道炎', '19', null, '1');
INSERT INTO `symptom` VALUES ('56', '妇科-卵巢囊肿', '19', null, '1');
INSERT INTO `symptom` VALUES ('57', '妇科-宫颈糜烂', '19', null, '1');
INSERT INTO `symptom` VALUES ('58', '眼科-干眼症', '20', null, '1');
INSERT INTO `symptom` VALUES ('59', '眼科-结膜炎', '20', null, '1');
INSERT INTO `symptom` VALUES ('60', '眼科-青光眼', '20', null, '1');
INSERT INTO `symptom` VALUES ('61', '骨科-先天畸形', '21', null, '1');
INSERT INTO `symptom` VALUES ('62', '骨科-骨结核', '21', null, '1');
INSERT INTO `symptom` VALUES ('63', '骨科-骨折', '21', null, '1');
INSERT INTO `symptom` VALUES ('64', '耳鼻喉-中耳炎', '22', null, '1');
INSERT INTO `symptom` VALUES ('65', '耳鼻喉-鼻息肉', '22', null, '1');
INSERT INTO `symptom` VALUES ('66', '耳鼻喉-腺样体肥大', '22', null, '1');
INSERT INTO `symptom` VALUES ('67', '心胸-心功能不全', '23', null, '1');
INSERT INTO `symptom` VALUES ('68', '心胸-冠心病', '23', null, '1');
INSERT INTO `symptom` VALUES ('69', '心胸-心肌炎', '23', null, '1');
INSERT INTO `symptom` VALUES ('70', '烧伤整形-烧/烫/冻伤', '24', null, '1');
INSERT INTO `symptom` VALUES ('71', '烧伤整形-皮肤撕脱伤', '24', null, '1');
INSERT INTO `symptom` VALUES ('72', '烧伤整形-整形美容', '24', null, '1');

-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password` char(60) NOT NULL,
  `user_type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10006 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('10001', 'yinadm', 'yin1234', 'Staff');
INSERT INTO `user` VALUES ('10002', 'yindoc', '123456', 'Doctor');
INSERT INTO `user` VALUES ('10003', 'yinnur', '123456', 'Nurse');
INSERT INTO `user` VALUES ('10004', 'yinpatient', 'yin123', 'Patient');
INSERT INTO `user` VALUES ('10005', 'yindoc2', '123456', 'Doctor');

-- ----------------------------
-- View structure for `bill_due`
-- ----------------------------
DROP VIEW IF EXISTS `bill_due`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bill_due` AS select `bill`.`id` AS `id`,(`bill`.`total_payable` - `bill`.`paid`) AS `due` from `bill` ;
DROP TRIGGER IF EXISTS `user_type_check`;
DELIMITER ;;
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
DELIMITER ;
DROP TRIGGER IF EXISTS `delete_on_pre_user`;
DELIMITER ;;
CREATE TRIGGER `delete_on_pre_user` AFTER DELETE ON `user` FOR EACH ROW BEGIN
	DELETE from pre_user 
    WHERE pre_user.username = old.username;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `user_delete`;
DELIMITER ;;
CREATE TRIGGER `user_delete` AFTER DELETE ON `user` FOR EACH ROW BEGIN
    delete from patient where patient.pid = old.id;
END
;;
DELIMITER ;
