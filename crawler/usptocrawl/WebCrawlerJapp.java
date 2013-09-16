import org.jsoup.nodes.*;
import org.jsoup.select.*;
import org.jsoup.*;
import org.json.*;

import java.io.*;
import java.util.*;

public class WebCrawlerJapp{
	protected static HashMap<String, String> applicantsMap = new HashMap<String, String>();
	protected static int acount = 0;
	
	protected static String searchApplicant(String applicant){
		String a_id = applicantsMap.get(applicant);
		if(a_id == null){
			acount++;
			a_id = "a"+acount;
			applicantsMap.put(applicant, a_id);
		}
		return a_id;
	}
	
	public static void main(String[] args) throws IOException{
		//int n = 4719;
		String dir = "patapps_dm/";
		StringBuffer sb = new StringBuffer();
 		//Vic's original for apps
		
		ArrayList<String> urlFront = new ArrayList<String>();
		ArrayList<String> urlBack = new ArrayList<String>();
		ArrayList<Integer> urlNum = new ArrayList<Integer>();
		
		//Inverters - 707
		//http://appft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.html&r=1&p=1&f=G&l=50&d=PG01&S1=%28inverter.CLM.+AND+photovoltaic.CLM.%29&OS=+%28ACLM/inverter+AND+%28ACLM/photovoltaic%29%29&RS=%28ACLM/inverter+AND+ACLM/photovoltaic%29
		String frontinv="http://appft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.html&r=";
		String backinv="&p=1&f=G&l=50&d=PG01&S1=%28inverter.CLM.+AND+photovoltaic.CLM.%29&OS=+%28ACLM/inverter+AND+%28ACLM/photovoltaic%29%29&RS=%28ACLM/inverter+AND+ACLM/photovoltaic%29";
		urlFront.add(frontinv);
		urlBack.add(backinv);
		urlNum.add(707);
		//Mounting-1-1447
		//http://appft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.html&r=1&p=1&f=G&l=50&d=PG01&S1=%28mounting.CLM.+AND+solar.CLM.%29&OS=+%28ACLM/mounting+AND+%28ACLM/solar%29%29&RS=%28ACLM/mounting+AND+ACLM/solar%29
		String frontmnt1="http://appft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.html&r=";
		String backmnt1="&p=1&f=G&l=50&d=PG01&S1=%28mounting.CLM.+AND+solar.CLM.%29&OS=+%28ACLM/mounting+AND+%28ACLM/solar%29%29&RS=%28ACLM/mounting+AND+ACLM/solar%29"; 
		urlFront.add(frontmnt1);
		urlBack.add(backmnt1);
		urlNum.add(1447);
		//Mounting-2-643
		//http://appft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.html&r=1&p=1&f=G&l=50&d=PG01&S1=%28mounting.CLM.+AND+photovoltaic.CLM.%29&OS=+%28ACLM/mounting+AND+%28ACLM/photovoltaic%29%29&RS=%28ACLM/mounting+AND+ACLM/photovoltaic%29
		String frontmnt2 = "http://appft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.html&r=";
		String backmnt2="&p=1&f=G&l=50&d=PG01&S1=%28mounting.CLM.+AND+photovoltaic.CLM.%29&OS=+%28ACLM/mounting+AND+%28ACLM/photovoltaic%29%29&RS=%28ACLM/mounting+AND+ACLM/photovoltaic%29";
		urlFront.add(frontmnt2);
		urlBack.add(backmnt2);
		urlNum.add(643);
		//Monitoring-1816
		//http://appft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.html&r=1&p=1&f=G&l=50&d=PG01&S1=%28%28solar.CLM.+AND+%28monitor.CLM.+OR+monitoring.CLM.%29%29+OR+%28photovoltaic.CLM.+AND+%28monitor.CLM.+OR+monitoring.CLM.%29%29%29&OS=+%28ACLM/solar+AND+%28ACLM/monitor+OR+ACLM/monitoring%29%29+OR+%28ACLM/photovoltaic+AND+%28ACLM/monitor+OR+ACLM/monitoring%29%29&RS=%28%28ACLM/solar+AND+%28ACLM/monitor+OR+ACLM/monitoring%29%29+OR+%28ACLM/photovoltaic+AND+%28ACLM/monitor+OR+ACLM/monitoring%29%29%29
		String frontmon="http://appft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.html&r=";
		String backmon="&p=1&f=G&l=50&d=PG01&S1=%28%28solar.CLM.+AND+%28monitor.CLM.+OR+monitoring.CLM.%29%29+OR+%28photovoltaic.CLM.+AND+%28monitor.CLM.+OR+monitoring.CLM.%29%29%29&OS=+%28ACLM/solar+AND+%28ACLM/monitor+OR+ACLM/monitoring%29%29+OR+%28ACLM/photovoltaic+AND+%28ACLM/monitor+OR+ACLM/monitoring%29%29&RS=%28%28ACLM/solar+AND+%28ACLM/monitor+OR+ACLM/monitoring%29%29+OR+%28ACLM/photovoltaic+AND+%28ACLM/monitor+OR+ACLM/monitoring%29%29%29"; 
		urlFront.add(frontmon);
		urlBack.add(backmon);
		urlNum.add(1816);
		//Site Assessment
		//http://appft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.html&r=1&p=1&f=G&l=50&d=PG01&S1=%28%28%28solar.CLM.+OR+photovoltaic.CLM.%29+AND+%28%28%28%28%28%28%28mapping.CLM.+OR+estimation.CLM.%29+OR+obstruction.CLM.%29+OR+potential.CLM.%29+OR+site.CLM.%29+OR+terrain.CLM.%29+OR+access.CLM.%29+OR+azimuth.CLM.%29%29+OR+survey.CLM.%29&OS=+%28%28ACLM/solar+OR+ACLM/photovoltaic%29+AND+%28%28%28%28%28%28%28ACLM/mapping+OR+ACLM/estimation%29+OR+ACLM/obstruction%29+OR+ACLM/potential%29+OR+ACLM/site%29+OR+ACLM/terrain%29+OR+ACLM/access%29+OR+ACLM/azimuth%29+OR+ACLM/survey%29&RS=%28%28%28ACLM/solar+OR+ACLM/photovoltaic%29+AND+%28%28%28%28%28%28%28ACLM/mapping+OR+ACLM/estimation%29+OR+ACLM/obstruction%29+OR+ACLM/potential%29+OR+ACLM/site%29+OR+ACLM/terrain%29+OR+ACLM/access%29+OR+ACLM/azimuth%29%29+OR+ACLM/survey%29
		//String front="patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.htm&r="; 
		//String back="&p=1&f=G&l=50&d=PTXT&S1=((((solar.CLTX.+or+solar.DCTX.)+OR+(photovoltaic.CLTX.+or+photovoltaic.DCTX.))+AND+((((((((mapping.CLTX.+or+mapping.DCTX.)+OR+(estimation.CLTX.+or+estimation.DCTX.))+OR+(obstruction.CLTX.+or+obstruction.DCTX.))+OR+(potential.CLTX.+or+potential.DCTX.))+OR+(site.CLTX.+or+site.DCTX.))+OR+(terrain.CLTX.+or+terrain.DCTX.))+OR+(access.CLTX.+or+access.DCTX.))+OR+(azimuth.CLTX.+or+azimuth.DCTX.)))+OR+(survey.CLTX.+or+survey.DCTX.))&OS=+((ACLM/solar+OR+ACLM/photovoltaic)+AND+(((((((ACLM/mapping+OR+ACLM/estimation)+OR+ACLM/obstruction)+OR+ACLM/potential)+OR+ACLM/site)+OR+ACLM/terrain)+OR+ACLM/access)+OR+ACLM/azimuth)+OR+ACLM/survey)&RS=(((ACLM/solar+OR+ACLM/photovoltaic)+AND+(((((((ACLM/mapping+OR+ACLM/estimation)+OR+ACLM/obstruction)+OR+ACLM/potential)+OR+ACLM/site)+OR+ACLM/terrain)+OR+ACLM/access)+OR+ACLM/azimuth))+OR+ACLM/survey)";
		
		File ids = new File("patapp_ids.csv");
		OutputStream pat_ids = new FileOutputStream(ids);
		String header="pat_id\n";
		pat_ids.write(header.getBytes());
		
		File pats = new File(dir+"patapps.csv");
		OutputStream pats_out = new FileOutputStream(pats);
		//String pats_header = "pat_id, title, USPA#, kind_code, date, serial#, series_code, field_date, us_class, pub_class, int_class, assignee, city, state\n";
		String pats_header = "pat_id, title, USPA#, date\n";
		pats_out.write(pats_header.getBytes());
		
		
		File file;
		OutputStream out;
		String p_id;
	
		//for(int ss=0; ss<urlFront.size(); ss++){
		{int ss=1;
		  String front=urlFront.get(ss);
		  String back=urlBack.get(ss);
		  //int n = urlNum.get(ss);
		  int n=1;
		
		for(int i = 0; i < n; i++){
			i=477;
			String patId = null;
			p_id = "pat"+ss+"_"+(i+1);
			sb = new StringBuffer();
			sb.append(front);
			sb.append(i+1);
			sb.append(back);
			System.out.println(sb);
			Connection connection = Jsoup.connect(sb.toString());
			connection.timeout(20000);
			Document doc = connection.get();
			
			
			System.out.printf("writing %s meta data...\n", p_id);
			try{
				sb = new StringBuffer();
				sb.append(p_id+", ");
				
				//Vic's
				//Element table1 = doc.getElementsContainingOwnText("Kind Code").get(0).parent().parent().parent();
				Elements usp = doc.getElementsContainingOwnText("United States");
				/*patId = usp.first().text().replaceAll("[^0-9]", "");
				StringBuffer idbuf = new StringBuffer();
				idbuf.append(patId+"\n");*/
				sb.append(doc.select("font[size=+1]").get(0).text().replace(",", " ")+", ");
				//Element usp = doc.select("td:containsOwn(United States)").first();
				//Element table1 = doc.getElementsContainingOwnText("United States Patent ").get(0).parent().parent().parent();
				Element table1 = usp.get(1).parent().parent().parent();
				patId = table1.getElementsByTag("tr").get(0).getElementsByTag("td").get(1).text().replace(",", "");
				StringBuffer idbuf = new StringBuffer();
				idbuf.append(patId+"\n");
				//Element table1 = doc.getElementsByAttributeValueContaining("B", "United States Patent").get(0).parent().parent().parent();
				sb.append(patId+", ");
				sb.append(table1.getElementsByTag("tr").get(1).getElementsByTag("td").get(1).text().replace(",", " ")+", ");
				//sb.append(table1.getElementsByTag("tr").get(2).getElementsByTag("td").get(1).text().replace(",", " ")+", ");
				//Element table2 = doc.getElementsContainingOwnText("Serial No.").get(0).parent().parent().parent();
				
				sb.append("\n");
				pats_out.write(sb.toString().getBytes());
				pat_ids.write(idbuf.toString().getBytes());
				
								
			}catch(Exception e){
				System.err.println("Cannot find metadata: "+e);
			}
			
			
			System.out.printf("writing %s content...\n", p_id);
			try{
				System.out.printf("writing %s abstract...\n", p_id);
				    if(patId==null)
				    	patId=p_id;
					file = new File(dir+patId+".txt");
					out = new FileOutputStream(file);
					String ab = doc.select("center>b").get(0).parent().nextElementSibling().text();
					out.write(ab.getBytes());
					out.write("\n".getBytes());
				
				Element content = doc.select("center>b>i").get(0).parent().parent().parent();
				String text = content.text();
				int ci = text.indexOf("Claims");
				int di = text.indexOf("Description");				
				out.write(text.substring(ci, di).getBytes());
				out.close();										
			}catch(Exception e){
				System.err.println("Cannot find claims: "+e);
			}
		}	
	
	}
		pats_out.close();
		pat_ids.close();
		
	}
}
