package model;
import java.io.Serializable;
public class Periodo implements Serializable {
    private int id; private String nombre; private int anio; private String descripcion; private boolean activo;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public String getNombre(){return nombre;} public void setNombre(String n){this.nombre=n;}
    public int getAnio(){return anio;} public void setAnio(int a){this.anio=a;}
    public String getDescripcion(){return descripcion;} public void setDescripcion(String d){this.descripcion=d;}
    public boolean isActivo(){return activo;} public void setActivo(boolean a){this.activo=a;}
}
