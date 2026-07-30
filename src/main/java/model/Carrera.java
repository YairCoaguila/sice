package model;
import java.io.Serializable;
public class Carrera implements Serializable {
    private int id; private String nombre; private int idArea; private String areaNombre; private String descripcion;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public String getNombre(){return nombre;} public void setNombre(String n){this.nombre=n;}
    public int getIdArea(){return idArea;} public void setIdArea(int a){this.idArea=a;}
    public String getAreaNombre(){return areaNombre;} public void setAreaNombre(String a){this.areaNombre=a;}
    public String getDescripcion(){return descripcion;} public void setDescripcion(String d){this.descripcion=d;}
}
