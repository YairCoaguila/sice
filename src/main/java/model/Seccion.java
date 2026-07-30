package model;
import java.io.Serializable;
public class Seccion implements Serializable {
    private int id; private String nombre; private int idGrado; private String gradoNombre;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public String getNombre(){return nombre;} public void setNombre(String n){this.nombre=n;}
    public int getIdGrado(){return idGrado;} public void setIdGrado(int g){this.idGrado=g;}
    public String getGradoNombre(){return gradoNombre;} public void setGradoNombre(String g){this.gradoNombre=g;}
}
