package model;
import java.io.Serializable;
import util.NombreUtil;
public class Docente implements Serializable {
    private int id; private String nombres; private String apellidoPaterno; private String apellidoMaterno;
    private String dni; private String celular; private String correo; private String especialidad; private String estado;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public String getNombres(){return NombreUtil.nombres(nombres);} public void setNombres(String n){this.nombres=n;}
    public String getApellidoPaterno(){return NombreUtil.apellidos(apellidoPaterno);} public void setApellidoPaterno(String a){this.apellidoPaterno=a;}
    public String getApellidoMaterno(){return NombreUtil.apellidos(apellidoMaterno);} public void setApellidoMaterno(String a){this.apellidoMaterno=a;}
    public String getDni(){return dni;} public void setDni(String d){this.dni=d;}
    public String getCelular(){return celular;} public void setCelular(String c){this.celular=c;}
    public String getCorreo(){return correo;} public void setCorreo(String e){this.correo=e;}
    public String getEspecialidad(){return especialidad;} public void setEspecialidad(String e){this.especialidad=e;}
    public String getEstado(){return estado;} public void setEstado(String e){this.estado=e;}
    public String getNombreCompleto(){return NombreUtil.completo(apellidoPaterno, apellidoMaterno, nombres);}
}
