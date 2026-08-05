package model;
import java.io.Serializable;
import java.time.LocalDateTime;
import util.NombreUtil;
public class Resultado implements Serializable {
    private int id; private int idAlumno; private int idExamen;
    private double puntaje; private int correctas; private int incorrectas; private int enBlanco; private double porcentaje;
    private LocalDateTime fechaRegistro;
    private String alumnoNombre; private String alumnoDni; private String examenNombre;
    private String gradoNombre; private String seccionNombre; private String carreraNombre;
    private int idGrado; private int idSeccion;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public int getIdAlumno(){return idAlumno;} public void setIdAlumno(int a){this.idAlumno=a;}
    public int getIdExamen(){return idExamen;} public void setIdExamen(int e){this.idExamen=e;}
    public double getPuntaje(){return puntaje;} public void setPuntaje(double p){this.puntaje=p;}
    public int getCorrectas(){return correctas;} public void setCorrectas(int c){this.correctas=c;}
    public int getIncorrectas(){return incorrectas;} public void setIncorrectas(int i){this.incorrectas=i;}
    public int getEnBlanco(){return enBlanco;} public void setEnBlanco(int b){this.enBlanco=b;}
    public double getPorcentaje(){return porcentaje;} public void setPorcentaje(double p){this.porcentaje=p;}
    public LocalDateTime getFechaRegistro(){return fechaRegistro;} public void setFechaRegistro(LocalDateTime f){this.fechaRegistro=f;}
    public String getAlumnoNombre(){return NombreUtil.desdeCompleto(alumnoNombre);} public void setAlumnoNombre(String a){this.alumnoNombre=a;}
    public String getAlumnoDni(){return alumnoDni;} public void setAlumnoDni(String a){this.alumnoDni=a;}
    public String getExamenNombre(){return examenNombre;} public void setExamenNombre(String e){this.examenNombre=e;}
    public String getGradoNombre(){return gradoNombre;} public void setGradoNombre(String g){this.gradoNombre=g;}
    public String getSeccionNombre(){return seccionNombre;} public void setSeccionNombre(String s){this.seccionNombre=s;}
    public String getCarreraNombre(){return carreraNombre;} public void setCarreraNombre(String c){this.carreraNombre=c;}
    public int getIdGrado(){return idGrado;} public void setIdGrado(int g){this.idGrado=g;}
    public int getIdSeccion(){return idSeccion;} public void setIdSeccion(int s){this.idSeccion=s;}
    private int rankingGeneral; private int rankingGrado;
    public int getRankingGeneral(){return rankingGeneral;} public void setRankingGeneral(int r){this.rankingGeneral=r;}
    public int getRankingGrado(){return rankingGrado;} public void setRankingGrado(int r){this.rankingGrado=r;}
}
