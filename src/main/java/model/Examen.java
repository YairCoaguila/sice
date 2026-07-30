package model;
import java.io.Serializable;
import java.time.LocalDate;
public class Examen implements Serializable {
    private int id; private String nombre; private LocalDate fecha; private int anio; private String periodo;
    private int idGrado; private int idArea; private int cantidadPreguntas; private double puntajeTotal; private String estado;
    private String gradoNombre; private String areaNombre;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public String getNombre(){return nombre;} public void setNombre(String n){this.nombre=n;}
    public LocalDate getFecha(){return fecha;} public void setFecha(LocalDate f){this.fecha=f;}
    public int getAnio(){return anio;} public void setAnio(int a){this.anio=a;}
    public String getPeriodo(){return periodo;} public void setPeriodo(String p){this.periodo=p;}
    public int getIdGrado(){return idGrado;} public void setIdGrado(int g){this.idGrado=g;}
    public int getIdArea(){return idArea;} public void setIdArea(int a){this.idArea=a;}
    public int getCantidadPreguntas(){return cantidadPreguntas;} public void setCantidadPreguntas(int c){this.cantidadPreguntas=c;}
    public double getPuntajeTotal(){return puntajeTotal;} public void setPuntajeTotal(double p){this.puntajeTotal=p;}
    public String getEstado(){return estado;} public void setEstado(String e){this.estado=e;}
    public String getGradoNombre(){return gradoNombre;} public void setGradoNombre(String g){this.gradoNombre=g;}
    public String getAreaNombre(){return areaNombre;} public void setAreaNombre(String a){this.areaNombre=a;}
}
