package com.phoenix.lotterys.buyhall.entity;

import java.util.List;

/**
 * @author : YH
 * @e-mail : YH9200811@163.com
 * @date : 2020/01/20 15:22
 * @description :
 */
public class TrendEntity {
    /**
     * game_id : 74
     * game_name : 极速赛车
     * ad :
     * total_issue : 288
     * had_open : 122
     * remain : 166
     * data : [{"time":"2020-01-20 10:05:00","timestamp":"1579485900","number":"2001200122","data":"05,04,03,02,06,08,07,10,01,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 10:00:00","timestamp":"1579485600","number":"2001200121","data":"02,03,06,05,07,08,10,01,09,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 09:55:00","timestamp":"1579485300","number":"2001200120","data":"10,07,03,09,05,08,01,02,06,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 09:50:00","timestamp":"1579485000","number":"2001200119","data":"06,10,01,08,02,09,07,03,04,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 09:45:00","timestamp":"1579484700","number":"2001200118","data":"02,03,04,05,01,06,09,07,10,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 09:40:00","timestamp":"1579484400","number":"2001200117","data":"10,08,05,02,04,07,01,06,09,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 09:35:00","timestamp":"1579484100","number":"2001200116","data":"04,03,02,06,09,05,01,08,07,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 09:30:00","timestamp":"1579483800","number":"2001200115","data":"07,05,03,02,06,08,01,04,09,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 09:25:00","timestamp":"1579483500","number":"2001200114","data":"08,06,03,02,10,07,01,04,09,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 09:20:00","timestamp":"1579483200","number":"2001200113","data":"04,07,10,05,02,06,08,03,01,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 09:15:00","timestamp":"1579482900","number":"2001200112","data":"03,02,07,08,09,01,05,06,10,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 09:10:00","timestamp":"1579482600","number":"2001200111","data":"08,03,07,01,10,04,05,02,09,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 09:05:00","timestamp":"1579482300","number":"2001200110","data":"09,06,02,07,04,05,03,01,10,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 09:00:00","timestamp":"1579482000","number":"2001200109","data":"05,01,10,09,02,07,03,08,04,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 08:55:00","timestamp":"1579481700","number":"2001200108","data":"03,10,02,06,09,08,01,04,05,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 08:50:00","timestamp":"1579481400","number":"2001200107","data":"05,07,01,09,04,10,08,06,03,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 08:45:00","timestamp":"1579481100","number":"2001200106","data":"01,02,03,06,09,08,05,10,04,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 08:40:00","timestamp":"1579480800","number":"2001200105","data":"05,02,06,07,10,03,08,04,09,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 08:35:00","timestamp":"1579480500","number":"2001200104","data":"03,07,08,06,01,10,05,02,04,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 08:30:00","timestamp":"1579480200","number":"2001200103","data":"01,10,07,04,03,08,09,06,05,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 08:25:00","timestamp":"1579479900","number":"2001200102","data":"07,06,04,08,05,09,03,01,02,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 08:20:00","timestamp":"1579479600","number":"2001200101","data":"03,10,04,09,07,06,05,01,02,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 08:15:00","timestamp":"1579479300","number":"2001200100","data":"10,07,01,08,06,05,04,02,09,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 08:10:00","timestamp":"1579479000","number":"2001200099","data":"07,08,02,06,01,03,04,10,09,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 08:05:00","timestamp":"1579478700","number":"2001200098","data":"08,01,05,03,09,02,10,04,06,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 08:00:00","timestamp":"1579478400","number":"2001200097","data":"08,05,10,09,01,03,06,02,07,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 07:55:00","timestamp":"1579478100","number":"2001200096","data":"09,10,01,02,08,05,07,04,03,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 07:50:00","timestamp":"1579477800","number":"2001200095","data":"07,09,03,08,06,02,04,05,10,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 07:45:00","timestamp":"1579477500","number":"2001200094","data":"06,10,02,04,01,07,08,05,09,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 07:40:00","timestamp":"1579477200","number":"2001200093","data":"02,04,06,09,07,08,01,03,05,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 07:35:00","timestamp":"1579476900","number":"2001200092","data":"04,01,06,03,08,05,09,10,02,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 07:30:00","timestamp":"1579476600","number":"2001200091","data":"07,05,03,09,04,08,02,10,06,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 07:25:00","timestamp":"1579476300","number":"2001200090","data":"10,08,03,09,07,04,06,05,01,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 07:20:00","timestamp":"1579476000","number":"2001200089","data":"07,08,10,06,04,05,02,09,01,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 07:15:00","timestamp":"1579475700","number":"2001200088","data":"04,02,05,10,03,07,08,01,09,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 07:10:00","timestamp":"1579475400","number":"2001200087","data":"08,10,07,01,03,09,06,05,04,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 07:05:00","timestamp":"1579475100","number":"2001200086","data":"08,04,07,10,03,06,02,01,05,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 07:00:00","timestamp":"1579474800","number":"2001200085","data":"04,07,09,08,10,01,05,06,02,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 06:55:00","timestamp":"1579474500","number":"2001200084","data":"09,10,06,01,05,07,02,04,08,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 06:50:00","timestamp":"1579474200","number":"2001200083","data":"02,04,01,07,03,10,06,05,09,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 06:45:00","timestamp":"1579473900","number":"2001200082","data":"06,01,09,04,07,05,08,02,10,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 06:40:00","timestamp":"1579473600","number":"2001200081","data":"05,01,04,10,08,06,02,09,07,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 06:35:00","timestamp":"1579473300","number":"2001200080","data":"08,09,10,03,02,04,05,06,07,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 06:30:00","timestamp":"1579473000","number":"2001200079","data":"07,03,04,05,09,10,02,01,08,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 06:25:00","timestamp":"1579472700","number":"2001200078","data":"08,02,09,01,10,06,03,07,05,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 06:20:00","timestamp":"1579472400","number":"2001200077","data":"07,08,06,04,09,05,10,03,01,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 06:15:00","timestamp":"1579472100","number":"2001200076","data":"09,04,07,06,02,03,05,08,01,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 06:10:00","timestamp":"1579471800","number":"2001200075","data":"06,10,02,04,05,01,03,09,08,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 06:05:00","timestamp":"1579471500","number":"2001200074","data":"02,10,06,01,08,03,05,09,07,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 06:00:00","timestamp":"1579471200","number":"2001200073","data":"01,02,03,09,07,06,04,05,08,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 05:55:00","timestamp":"1579470900","number":"2001200072","data":"03,04,02,08,01,06,09,10,07,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 05:50:00","timestamp":"1579470600","number":"2001200071","data":"08,10,03,04,07,05,06,09,02,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 05:45:00","timestamp":"1579470300","number":"2001200070","data":"03,01,09,02,05,04,07,08,10,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 05:40:00","timestamp":"1579470000","number":"2001200069","data":"09,06,10,04,07,01,03,08,05,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 05:35:00","timestamp":"1579469700","number":"2001200068","data":"10,04,03,01,07,09,02,05,08,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 05:30:00","timestamp":"1579469400","number":"2001200067","data":"08,09,04,03,06,10,05,07,01,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 05:25:00","timestamp":"1579469100","number":"2001200066","data":"06,09,03,05,04,01,08,07,10,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 05:20:00","timestamp":"1579468800","number":"2001200065","data":"06,08,03,05,04,01,09,10,07,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 05:15:00","timestamp":"1579468500","number":"2001200064","data":"05,08,03,01,10,04,09,06,07,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 05:10:00","timestamp":"1579468200","number":"2001200063","data":"03,01,06,10,07,04,02,08,05,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 05:05:00","timestamp":"1579467900","number":"2001200062","data":"02,07,04,10,09,05,01,03,08,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 05:00:00","timestamp":"1579467600","number":"2001200061","data":"04,09,01,03,08,07,02,05,10,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 04:55:00","timestamp":"1579467300","number":"2001200060","data":"07,03,01,10,02,05,09,04,08,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 04:50:00","timestamp":"1579467000","number":"2001200059","data":"06,05,08,03,04,01,09,02,10,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 04:45:00","timestamp":"1579466700","number":"2001200058","data":"05,02,08,10,07,03,06,01,04,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 04:40:00","timestamp":"1579466400","number":"2001200057","data":"09,08,05,02,10,04,01,07,06,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 04:35:00","timestamp":"1579466100","number":"2001200056","data":"07,04,05,09,02,08,01,03,06,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 04:30:00","timestamp":"1579465800","number":"2001200055","data":"06,10,07,03,05,04,02,09,01,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 04:25:00","timestamp":"1579465500","number":"2001200054","data":"01,09,07,04,03,02,08,10,06,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 04:20:00","timestamp":"1579465200","number":"2001200053","data":"06,03,10,07,02,01,04,05,08,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 04:15:00","timestamp":"1579464900","number":"2001200052","data":"08,09,04,03,10,07,01,05,06,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 04:10:00","timestamp":"1579464600","number":"2001200051","data":"09,10,08,01,06,04,02,05,07,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 04:05:00","timestamp":"1579464300","number":"2001200050","data":"06,08,02,10,03,09,05,04,07,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 04:00:00","timestamp":"1579464000","number":"2001200049","data":"05,03,07,01,08,04,09,06,02,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 03:55:00","timestamp":"1579463700","number":"2001200048","data":"10,09,08,06,01,07,03,04,02,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 03:50:00","timestamp":"1579463400","number":"2001200047","data":"01,09,03,07,05,04,08,06,02,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 03:45:00","timestamp":"1579463100","number":"2001200046","data":"02,10,04,06,03,01,08,07,09,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 03:40:00","timestamp":"1579462800","number":"2001200045","data":"01,07,08,09,02,06,04,03,10,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 03:35:00","timestamp":"1579462500","number":"2001200044","data":"02,04,08,01,03,07,05,10,09,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 03:30:00","timestamp":"1579462200","number":"2001200043","data":"06,01,04,05,07,08,02,10,03,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 03:25:00","timestamp":"1579461900","number":"2001200042","data":"08,03,09,04,07,01,10,06,02,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 03:20:00","timestamp":"1579461600","number":"2001200041","data":"09,01,07,05,03,02,06,10,04,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 03:15:00","timestamp":"1579461300","number":"2001200040","data":"10,09,07,02,05,08,01,03,06,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 03:10:00","timestamp":"1579461000","number":"2001200039","data":"05,10,03,06,09,02,04,08,07,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 03:05:00","timestamp":"1579460700","number":"2001200038","data":"07,04,06,03,09,10,02,05,08,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 03:00:00","timestamp":"1579460400","number":"2001200037","data":"08,05,04,07,06,09,03,10,02,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 02:55:00","timestamp":"1579460100","number":"2001200036","data":"10,06,09,01,04,05,02,08,07,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 02:50:00","timestamp":"1579459800","number":"2001200035","data":"03,06,10,09,05,07,02,08,01,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 02:45:00","timestamp":"1579459500","number":"2001200034","data":"04,09,07,01,03,08,10,06,02,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 02:40:00","timestamp":"1579459200","number":"2001200033","data":"02,10,07,01,04,06,05,03,08,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 02:35:00","timestamp":"1579458900","number":"2001200032","data":"03,04,02,06,08,07,10,01,05,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 02:30:00","timestamp":"1579458600","number":"2001200031","data":"09,06,10,02,08,05,04,07,01,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 02:25:00","timestamp":"1579458300","number":"2001200030","data":"08,03,01,07,06,05,04,02,10,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 02:20:00","timestamp":"1579458000","number":"2001200029","data":"09,05,08,06,03,02,04,10,01,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 02:15:00","timestamp":"1579457700","number":"2001200028","data":"09,04,03,05,07,06,01,02,08,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 02:10:00","timestamp":"1579457400","number":"2001200027","data":"06,08,01,07,04,02,10,05,03,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 02:05:00","timestamp":"1579457100","number":"2001200026","data":"02,10,05,06,03,08,04,07,09,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 02:00:00","timestamp":"1579456800","number":"2001200025","data":"10,03,08,07,01,06,09,02,04,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 01:55:00","timestamp":"1579456500","number":"2001200024","data":"10,05,02,01,09,06,08,07,04,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 01:50:00","timestamp":"1579456200","number":"2001200023","data":"07,09,10,03,02,01,06,05,04,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 01:45:00","timestamp":"1579455900","number":"2001200022","data":"08,10,09,03,06,04,01,07,02,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 01:40:00","timestamp":"1579455600","number":"2001200021","data":"08,04,06,07,02,09,01,03,10,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 01:35:00","timestamp":"1579455300","number":"2001200020","data":"09,02,04,01,07,03,06,08,10,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 01:30:00","timestamp":"1579455000","number":"2001200019","data":"07,06,03,08,01,02,04,05,10,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 01:25:00","timestamp":"1579454700","number":"2001200018","data":"05,01,09,07,03,08,02,10,04,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 01:20:00","timestamp":"1579454400","number":"2001200017","data":"10,04,02,06,09,01,07,05,08,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 01:15:00","timestamp":"1579454100","number":"2001200016","data":"04,09,05,10,02,03,07,01,08,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 01:10:00","timestamp":"1579453800","number":"2001200015","data":"05,03,06,08,07,09,10,01,02,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 01:05:00","timestamp":"1579453500","number":"2001200014","data":"07,02,01,05,04,09,06,10,03,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 01:00:00","timestamp":"1579453200","number":"2001200013","data":"09,08,10,05,02,06,03,04,07,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 00:55:00","timestamp":"1579452900","number":"2001200012","data":"05,03,08,09,06,04,07,01,02,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 00:50:00","timestamp":"1579452600","number":"2001200011","data":"08,07,09,04,06,10,01,02,03,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 00:45:00","timestamp":"1579452300","number":"2001200010","data":"06,07,09,04,05,08,03,02,10,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 00:40:00","timestamp":"1579452000","number":"2001200009","data":"02,07,08,03,05,06,04,10,01,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 00:35:00","timestamp":"1579451700","number":"2001200008","data":"01,06,05,04,08,03,09,02,07,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 00:30:00","timestamp":"1579451400","number":"2001200007","data":"09,03,06,02,01,04,05,10,08,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 00:25:00","timestamp":"1579451100","number":"2001200006","data":"03,09,10,07,01,02,05,08,06,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 00:20:00","timestamp":"1579450800","number":"2001200005","data":"01,07,10,05,08,02,06,03,09,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 00:15:00","timestamp":"1579450500","number":"2001200004","data":"06,09,07,02,05,08,10,03,01,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 00:10:00","timestamp":"1579450200","number":"2001200003","data":"04,02,05,06,09,08,03,10,07,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 00:05:00","timestamp":"1579449900","number":"2001200002","data":"09,02,10,04,08,07,03,06,01,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-20 00:00:00","timestamp":"1579449600","number":"2001200001","data":"09,04,06,02,01,10,08,07,03,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 23:55:00","timestamp":"1579449300","number":"2001190288","data":"02,07,09,05,01,04,03,10,06,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 23:50:00","timestamp":"1579449000","number":"2001190287","data":"03,10,08,06,09,02,05,04,07,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 23:45:00","timestamp":"1579448700","number":"2001190286","data":"09,05,06,02,07,04,08,03,10,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 23:40:00","timestamp":"1579448400","number":"2001190285","data":"04,09,07,05,08,10,06,03,02,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 23:35:00","timestamp":"1579448100","number":"2001190284","data":"01,10,06,04,07,09,03,02,08,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 23:30:00","timestamp":"1579447800","number":"2001190283","data":"04,07,05,10,08,06,01,02,03,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 23:25:00","timestamp":"1579447500","number":"2001190282","data":"03,06,07,05,08,01,04,09,02,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 23:20:00","timestamp":"1579447200","number":"2001190281","data":"06,08,04,05,01,07,03,02,09,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 23:15:00","timestamp":"1579446900","number":"2001190280","data":"06,05,07,09,03,01,10,08,04,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 23:10:00","timestamp":"1579446600","number":"2001190279","data":"03,08,10,02,04,09,06,07,05,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 23:05:00","timestamp":"1579446300","number":"2001190278","data":"04,02,01,03,08,05,10,07,06,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 23:00:00","timestamp":"1579446000","number":"2001190277","data":"06,03,05,08,02,01,04,10,09,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 22:55:00","timestamp":"1579445700","number":"2001190276","data":"01,08,06,02,07,10,05,03,04,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 22:50:00","timestamp":"1579445400","number":"2001190275","data":"07,06,09,10,04,01,05,02,03,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 22:45:00","timestamp":"1579445100","number":"2001190274","data":"07,10,04,09,06,08,02,03,01,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 22:40:00","timestamp":"1579444800","number":"2001190273","data":"10,02,03,07,09,05,06,01,04,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 22:35:00","timestamp":"1579444500","number":"2001190272","data":"02,10,01,04,06,09,07,08,03,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 22:30:00","timestamp":"1579444200","number":"2001190271","data":"07,06,09,05,04,02,08,10,01,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 22:25:00","timestamp":"1579443900","number":"2001190270","data":"05,06,08,07,10,04,09,02,03,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 22:20:00","timestamp":"1579443600","number":"2001190269","data":"09,07,10,02,08,03,01,06,04,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 22:15:00","timestamp":"1579443300","number":"2001190268","data":"04,08,10,01,02,09,05,06,07,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 22:10:00","timestamp":"1579443000","number":"2001190267","data":"07,05,09,03,02,04,01,10,08,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 22:05:00","timestamp":"1579442700","number":"2001190266","data":"06,10,05,02,08,07,01,04,09,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 22:00:00","timestamp":"1579442400","number":"2001190265","data":"06,02,08,03,10,05,07,01,04,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 21:55:00","timestamp":"1579442100","number":"2001190264","data":"05,06,09,08,10,02,07,03,04,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 21:50:00","timestamp":"1579441800","number":"2001190263","data":"05,07,06,09,08,04,02,10,03,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 21:45:00","timestamp":"1579441500","number":"2001190262","data":"09,10,05,02,06,07,03,04,08,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 21:40:00","timestamp":"1579441200","number":"2001190261","data":"04,06,07,05,08,03,09,10,01,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 21:35:00","timestamp":"1579440900","number":"2001190260","data":"07,09,01,05,08,04,03,10,02,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 21:30:00","timestamp":"1579440600","number":"2001190259","data":"04,02,01,09,03,10,07,08,05,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 21:25:00","timestamp":"1579440300","number":"2001190258","data":"10,09,06,02,05,01,08,03,07,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 21:20:00","timestamp":"1579440000","number":"2001190257","data":"06,10,08,09,01,03,04,05,02,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 21:15:00","timestamp":"1579439700","number":"2001190256","data":"02,01,04,05,06,10,09,07,03,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 21:10:00","timestamp":"1579439400","number":"2001190255","data":"01,06,10,02,03,07,04,09,08,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 21:05:00","timestamp":"1579439100","number":"2001190254","data":"07,02,03,01,09,05,06,04,08,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 21:00:00","timestamp":"1579438800","number":"2001190253","data":"02,01,09,10,06,05,03,07,04,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 20:55:00","timestamp":"1579438500","number":"2001190252","data":"08,06,03,05,10,04,02,09,01,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 20:50:00","timestamp":"1579438200","number":"2001190251","data":"02,01,08,05,10,09,07,04,03,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 20:45:00","timestamp":"1579437900","number":"2001190250","data":"05,07,03,06,08,02,10,01,09,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 20:40:00","timestamp":"1579437600","number":"2001190249","data":"08,06,01,05,09,04,10,02,07,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 20:35:00","timestamp":"1579437300","number":"2001190248","data":"02,10,08,06,09,04,05,01,07,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 20:30:00","timestamp":"1579437000","number":"2001190247","data":"09,04,06,08,02,05,03,07,01,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 20:25:00","timestamp":"1579436700","number":"2001190246","data":"01,07,06,09,05,02,04,08,03,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 20:20:00","timestamp":"1579436400","number":"2001190245","data":"07,03,09,04,05,02,08,01,10,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 20:15:00","timestamp":"1579436100","number":"2001190244","data":"09,03,02,06,04,08,05,10,01,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 20:10:00","timestamp":"1579435800","number":"2001190243","data":"04,02,01,03,08,10,07,05,09,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 20:05:00","timestamp":"1579435500","number":"2001190242","data":"10,08,05,01,04,07,02,03,06,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 20:00:00","timestamp":"1579435200","number":"2001190241","data":"08,05,07,02,09,03,04,10,06,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 19:55:00","timestamp":"1579434900","number":"2001190240","data":"03,01,10,07,06,08,04,05,02,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 19:50:00","timestamp":"1579434600","number":"2001190239","data":"01,09,04,05,08,07,02,03,10,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 19:45:00","timestamp":"1579434300","number":"2001190238","data":"06,01,08,02,05,04,03,09,07,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 19:40:00","timestamp":"1579434000","number":"2001190237","data":"04,08,01,05,02,03,10,07,09,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 19:35:00","timestamp":"1579433700","number":"2001190236","data":"05,03,09,10,02,01,06,04,07,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 19:30:00","timestamp":"1579433400","number":"2001190235","data":"01,06,04,05,03,07,02,09,10,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 19:25:00","timestamp":"1579433100","number":"2001190234","data":"04,10,08,01,02,09,05,03,07,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 19:20:00","timestamp":"1579432800","number":"2001190233","data":"03,06,10,04,07,01,08,05,09,02","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 19:15:00","timestamp":"1579432500","number":"2001190232","data":"02,07,05,08,10,06,04,01,09,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 19:10:00","timestamp":"1579432200","number":"2001190231","data":"10,09,03,05,04,01,02,07,08,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 19:05:00","timestamp":"1579431900","number":"2001190230","data":"01,10,07,04,06,03,08,05,02,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 19:00:00","timestamp":"1579431600","number":"2001190229","data":"08,09,06,05,07,10,04,02,01,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 18:55:00","timestamp":"1579431300","number":"2001190228","data":"01,02,04,10,07,08,06,05,03,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 18:50:00","timestamp":"1579431000","number":"2001190227","data":"02,04,08,06,05,03,10,09,01,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 18:45:00","timestamp":"1579430700","number":"2001190226","data":"02,01,03,09,04,10,05,07,06,08","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 18:40:00","timestamp":"1579430400","number":"2001190225","data":"07,05,01,02,08,04,09,10,03,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 18:35:00","timestamp":"1579430100","number":"2001190224","data":"10,02,03,06,04,07,09,01,08,05","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 18:30:00","timestamp":"1579429800","number":"2001190223","data":"04,10,02,09,05,08,06,07,03,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 18:25:00","timestamp":"1579429500","number":"2001190222","data":"10,01,02,04,08,06,05,03,07,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 18:20:00","timestamp":"1579429200","number":"2001190221","data":"01,05,09,06,02,07,03,08,10,04","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 18:15:00","timestamp":"1579428900","number":"2001190220","data":"08,03,02,04,05,09,07,06,10,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 18:10:00","timestamp":"1579428600","number":"2001190219","data":"10,04,02,01,06,09,08,05,03,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 18:05:00","timestamp":"1579428300","number":"2001190218","data":"08,10,09,03,04,02,06,07,05,01","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 18:00:00","timestamp":"1579428000","number":"2001190217","data":"06,04,05,02,08,01,10,09,03,07","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 17:55:00","timestamp":"1579427700","number":"2001190216","data":"02,05,07,04,08,09,10,06,01,03","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 17:50:00","timestamp":"1579427400","number":"2001190215","data":"02,09,08,07,05,01,03,06,04,10","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 17:45:00","timestamp":"1579427100","number":"2001190214","data":"01,07,08,10,02,09,05,03,04,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 17:40:00","timestamp":"1579426800","number":"2001190213","data":"01,05,03,02,08,04,10,07,09,06","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 17:35:00","timestamp":"1579426500","number":"2001190212","data":"05,10,04,08,07,01,02,06,03,09","preNumColor":null,"preNumSx":null},{"time":"2020-01-19 17:30:00","timestamp":"1579426200","number":"2001190211","data":"04,10,07,08,06,09,05,02,03,01","preNumColor":null,"preNumSx":null}]
     * next : {"time":"2020-01-20 10:10:00","timestamp":1579486200,"number":"2001200123","remain":79}
     * current : {"time":"2020-01-20 10:05:00","timestamp":"1579485900","number":"2001200122","data":"05,04,03,02,06,08,07,10,01,09","preNumColor":null,"preNumSx":null}
     * serverTime : 1579486121
     * gameMark : jsscpk10
     */

    private int game_id;
    private String game_name;
    private String ad;
    private String total_issue;
    private int had_open;
    private int remain;
    private NextBean next;
    private CurrentBean current;
    private String serverTime;
    private String gameMark;
    private List<DataBean> data;

    public int getGame_id() {
        return game_id;
    }

    public void setGame_id(int game_id) {
        this.game_id = game_id;
    }

    public String getGame_name() {
        return game_name;
    }

    public void setGame_name(String game_name) {
        this.game_name = game_name;
    }

    public String getAd() {
        return ad;
    }

    public void setAd(String ad) {
        this.ad = ad;
    }

    public String getTotal_issue() {
        return total_issue;
    }

    public void setTotal_issue(String total_issue) {
        this.total_issue = total_issue;
    }

    public int getHad_open() {
        return had_open;
    }

    public void setHad_open(int had_open) {
        this.had_open = had_open;
    }

    public int getRemain() {
        return remain;
    }

    public void setRemain(int remain) {
        this.remain = remain;
    }

    public NextBean getNext() {
        return next;
    }

    public void setNext(NextBean next) {
        this.next = next;
    }

    public CurrentBean getCurrent() {
        return current;
    }

    public void setCurrent(CurrentBean current) {
        this.current = current;
    }

    public String getServerTime() {
        return serverTime;
    }

    public void setServerTime(String serverTime) {
        this.serverTime = serverTime;
    }

    public String getGameMark() {
        return gameMark;
    }

    public void setGameMark(String gameMark) {
        this.gameMark = gameMark;
    }

    public List<DataBean> getData() {
        return data;
    }

    public void setData(List<DataBean> data) {
        this.data = data;
    }

    public static class NextBean {
        /**
         * time : 2020-01-20 10:10:00
         * timestamp : 1579486200
         * number : 2001200123
         * remain : 79
         */

        private String time;
        private int timestamp;
        private String number;
        private int remain;

        public String getTime() {
            return time;
        }

        public void setTime(String time) {
            this.time = time;
        }

        public int getTimestamp() {
            return timestamp;
        }

        public void setTimestamp(int timestamp) {
            this.timestamp = timestamp;
        }

        public String getNumber() {
            return number;
        }

        public void setNumber(String number) {
            this.number = number;
        }

        public int getRemain() {
            return remain;
        }

        public void setRemain(int remain) {
            this.remain = remain;
        }
    }

    public static class CurrentBean {
        /**
         * time : 2020-01-20 10:05:00
         * timestamp : 1579485900
         * number : 2001200122
         * data : 05,04,03,02,06,08,07,10,01,09
         * preNumColor : null
         * preNumSx : null
         */

        private String time;
        private String timestamp;
        private String number;
        private String data;
        private Object preNumColor;
        private Object preNumSx;

        public String getTime() {
            return time;
        }

        public void setTime(String time) {
            this.time = time;
        }

        public String getTimestamp() {
            return timestamp;
        }

        public void setTimestamp(String timestamp) {
            this.timestamp = timestamp;
        }

        public String getNumber() {
            return number;
        }

        public void setNumber(String number) {
            this.number = number;
        }

        public String getData() {
            return data;
        }

        public void setData(String data) {
            this.data = data;
        }

        public Object getPreNumColor() {
            return preNumColor;
        }

        public void setPreNumColor(Object preNumColor) {
            this.preNumColor = preNumColor;
        }

        public Object getPreNumSx() {
            return preNumSx;
        }

        public void setPreNumSx(Object preNumSx) {
            this.preNumSx = preNumSx;
        }
    }

    public static class DataBean {
        /**
         * time : 2020-01-20 10:05:00
         * timestamp : 1579485900
         * number : 2001200122
         * data : 05,04,03,02,06,08,07,10,01,09
         * preNumColor : null
         * preNumSx : null
         */

        private String time;
        private String timestamp;
        private String number;
        private String data;
        private Object preNumColor;
        private Object preNumSx;

        public String getTime() {
            return time;
        }

        public void setTime(String time) {
            this.time = time;
        }

        public String getTimestamp() {
            return timestamp;
        }

        public void setTimestamp(String timestamp) {
            this.timestamp = timestamp;
        }

        public String getNumber() {
            return number;
        }

        public void setNumber(String number) {
            this.number = number;
        }

        public String getData() {
            return data;
        }

        public void setData(String data) {
            this.data = data;
        }

        public Object getPreNumColor() {
            return preNumColor;
        }

        public void setPreNumColor(Object preNumColor) {
            this.preNumColor = preNumColor;
        }

        public Object getPreNumSx() {
            return preNumSx;
        }

        public void setPreNumSx(Object preNumSx) {
            this.preNumSx = preNumSx;
        }
    }
}
