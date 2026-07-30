package model;
import java.io.Serializable;
public class Area implements Serializable {
    private int id; private String nombre; private String descripcion;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public String getNombre(){return nombre;} public void setNombre(String n){this.nombre=n;}
    public String getDescripcion(){return descripcion;} public void setDescripcion(String d){this.descripcion=d;}
}
