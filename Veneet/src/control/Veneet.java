package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import model.Vene;
import model.dao.Dao;

@WebServlet("/veneet/*")
public class Veneet extends HttpServlet {
	private static final long serialVersionUID = 1L;
 
    public Veneet() {
        super();
        System.out.println("Veneet.Veneet()");
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet.doGet()");
		String pathInfo = request.getPathInfo();
		System.out.println("polku: "+pathInfo);
		Dao dao = new Dao();
        ArrayList<Vene> veneet;
        String strJSON="";
        if(pathInfo==null) {
        	veneet = dao.listaaKaikki();
        	strJSON = new JSONObject().put("veneet", veneet).toString();
        } else if(pathInfo.indexOf("haeyksi")!=-1) {
        	String tunnus = pathInfo.replace("/haeyksi/", "");
        	Vene vene = dao.etsiVene(tunnus);
        	JSONObject JSON = new JSONObject();
        	JSON.put("nimi", vene.getNimi());
        	JSON.put("merkkimalli", vene.getMerkkimalli());
        	JSON.put("pituus", vene.getPituus());
        	JSON.put("leveys", vene.getLeveys());
        	JSON.put("hinta", vene.getHinta());
        	strJSON = JSON.toString();
        } else {
        	String hakusana = pathInfo.replace("/", "");
        	veneet = dao.listaaKaikki(hakusana);
        	strJSON = new JSONObject().put("veneet", veneet).toString();
        }
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.println(strJSON);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet.doPost()");
		JSONObject jsonObj = new JsonStrToObj().convert(request);
		Vene vene = new Vene();
		vene.setNimi(jsonObj.getString("nimi"));
		vene.setMerkkimalli(jsonObj.getString("merkkimalli"));
		vene.setPituus(jsonObj.getDouble("pituus"));
		vene.setLeveys(jsonObj.getDouble("leveys"));
		vene.setHinta(jsonObj.getInt("hinta"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();
		if(dao.lisaaVene(vene)) {
			out.println("{\"response\":1}");
		} else {
			out.println("{\"response\":0}");
		}
	}

	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet.doPut()");
		JSONObject jsonObj = new JsonStrToObj().convert(request);
		String tunnus = jsonObj.getString("tunnus");
		Vene vene = new Vene();
		vene.setNimi(jsonObj.getString("nimi"));
		vene.setMerkkimalli(jsonObj.getString("merkkimalli"));
		vene.setPituus(jsonObj.getDouble("pituus"));
		vene.setLeveys(jsonObj.getDouble("leveys"));
		vene.setHinta(jsonObj.getInt("hinta"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();
		if(dao.muutaVene(vene, tunnus)) {
			out.println("{\"response\":1}");
		} else {
			out.println("{\"response\":0}");
		}
	}

	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet.doDelete()");
		String pathInfo = request.getPathInfo();
		System.out.println("polku: "+pathInfo);
		int poistettavaTunnus = Integer.parseInt(pathInfo.replace("/", ""));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();
		if(dao.poistaVene(poistettavaTunnus)) {
			out.println("{\"response\":1}");
		} else {
			out.println("{\"response\":0}");
		}
	}

}
