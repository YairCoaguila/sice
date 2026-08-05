package model;
import java.io.Serializable;
import util.NombreUtil;
public class DocenteAula implements Serializable {
    private int id; private int idDocente; private int idGrado; private int idSeccion; private int anio; private String periodo;
    private String docenteNombre; private String gradoNombre; private String seccionNombre;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public int getIdDocente(){return idDocente;} public void setIdDocente(int d){this.idDocente=d;}
    public int getIdGrado(){return idGrado;} public void setIdGrado(int g){this.idGrado=g;}
    public int getIdSeccion(){return idSeccion;} public void setIdSeccion(int s){this.idSeccion=s;}
    public int getAnio(){return anio;} public void setAnio(int a){this.anio=a;}
    public String getPeriodo(){return periodo;} public void setPeriodo(String p){this.periodo=p;}
    public String getDocenteNombre(){return NombreUtil.desdeCompleto(docenteNombre);} public void setDocenteNombre(String d){this.docenteNombre=d;}
    public String getGradoNombre(){return gradoNombre;} public void setGradoNombre(String g){this.gradoNombre=g;}
    public String getSeccionNombre(){return seccionNombre;} public void setSeccionNombre(String s){this.seccionNombre=s;}
}
