package model;
import java.io.Serializable;
import util.NombreUtil;
public class ExamenAsignacion implements Serializable {
    private int id; private int idExamen; private int idDocente; private int idAula;
    private String examenNombre; private int examenAnio; private String examenPeriodo;
    private String docenteNombre; private String aulaCodigo; private int aulaCapacidad;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public int getIdExamen(){return idExamen;} public void setIdExamen(int e){this.idExamen=e;}
    public int getIdDocente(){return idDocente;} public void setIdDocente(int d){this.idDocente=d;}
    public int getIdAula(){return idAula;} public void setIdAula(int a){this.idAula=a;}
    public String getExamenNombre(){return examenNombre;} public void setExamenNombre(String e){this.examenNombre=e;}
    public int getExamenAnio(){return examenAnio;} public void setExamenAnio(int a){this.examenAnio=a;}
    public String getExamenPeriodo(){return examenPeriodo;} public void setExamenPeriodo(String p){this.examenPeriodo=p;}
    public String getDocenteNombre(){return NombreUtil.desdeCompleto(docenteNombre);} public void setDocenteNombre(String d){this.docenteNombre=d;}
    public String getAulaCodigo(){return aulaCodigo;} public void setAulaCodigo(String a){this.aulaCodigo=a;}
    public int getAulaCapacidad(){return aulaCapacidad;} public void setAulaCapacidad(int a){this.aulaCapacidad=a;}
}
