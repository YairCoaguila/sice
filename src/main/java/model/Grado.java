package model;
import java.io.Serializable;
public class Grado implements Serializable {
    private int id; private String nombre; private int nivel; private boolean participa;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public String getNombre(){return nombre;} public void setNombre(String n){this.nombre=n;}
    public int getNivel(){return nivel;} public void setNivel(int n){this.nivel=n;}
    public boolean isParticipa(){return participa;} public void setParticipa(boolean p){this.participa=p;}
}
