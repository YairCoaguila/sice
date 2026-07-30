package model;
import java.io.Serializable;
public class Aula implements Serializable {
    private int id; private String codigo; private int capacidad; private String descripcion;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public String getCodigo(){return codigo;} public void setCodigo(String c){this.codigo=c;}
    public int getCapacidad(){return capacidad;} public void setCapacidad(int c){this.capacidad=c;}
    public String getDescripcion(){return descripcion;} public void setDescripcion(String d){this.descripcion=d;}
}
