package model;
import java.io.Serializable;
public class Usuario implements Serializable {
    private int id; private String username; private String password; private String rol; private String estado;
    private int idDocente;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public String getUsername(){return username;} public void setUsername(String u){this.username=u;}
    public String getPassword(){return password;} public void setPassword(String p){this.password=p;}
    public String getRol(){return rol;} public void setRol(String r){this.rol=r;}
    public String getEstado(){return estado;} public void setEstado(String e){this.estado=e;}
    public int getIdDocente(){return idDocente;} public void setIdDocente(int d){this.idDocente=d;}
    public boolean hasDocente(){return idDocente>0;}
    public boolean isAdmin(){return "administrador".equalsIgnoreCase(rol);}
    public boolean isDocente(){return "docente".equalsIgnoreCase(rol);}
    public boolean isDigitador(){return "digitador".equalsIgnoreCase(rol);}
}
