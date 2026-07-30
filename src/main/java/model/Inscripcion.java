package model;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
public class Inscripcion implements Serializable {
    private int id; private String codigoInscripcion; private int idAlumno; private int idExamen; private int idCarrera;
    private int anio; private String periodo; private LocalDateTime fechaInscripcion; private String estado;
    private int idAula; private String aulaCodigo;
    private String alumnoNombre; private String alumnoDni; private String examenNombre;
    private String carreraNombre; private String areaNombre; private String gradoNombre; private String seccionNombre;
    private LocalDate examenFecha; private int idGrado; private int idSeccion;
    public int getId(){return id;} public void setId(int id){this.id=id;}
    public String getCodigoInscripcion(){return codigoInscripcion;} public void setCodigoInscripcion(String c){this.codigoInscripcion=c;}
    public int getIdAlumno(){return idAlumno;} public void setIdAlumno(int a){this.idAlumno=a;}
    public int getIdExamen(){return idExamen;} public void setIdExamen(int e){this.idExamen=e;}
    public int getIdCarrera(){return idCarrera;} public void setIdCarrera(int c){this.idCarrera=c;}
    public int getAnio(){return anio;} public void setAnio(int a){this.anio=a;}
    public String getPeriodo(){return periodo;} public void setPeriodo(String p){this.periodo=p;}
    public LocalDateTime getFechaInscripcion(){return fechaInscripcion;} public void setFechaInscripcion(LocalDateTime f){this.fechaInscripcion=f;}
    public String getEstado(){return estado;} public void setEstado(String e){this.estado=e;}
    public String getAlumnoNombre(){return alumnoNombre;} public void setAlumnoNombre(String a){this.alumnoNombre=a;}
    public String getAlumnoDni(){return alumnoDni;} public void setAlumnoDni(String a){this.alumnoDni=a;}
    public String getExamenNombre(){return examenNombre;} public void setExamenNombre(String e){this.examenNombre=e;}
    public String getCarreraNombre(){return carreraNombre;} public void setCarreraNombre(String c){this.carreraNombre=c;}
    public String getAreaNombre(){return areaNombre;} public void setAreaNombre(String a){this.areaNombre=a;}
    public String getGradoNombre(){return gradoNombre;} public void setGradoNombre(String g){this.gradoNombre=g;}
    public String getSeccionNombre(){return seccionNombre;} public void setSeccionNombre(String s){this.seccionNombre=s;}
    public LocalDate getExamenFecha(){return examenFecha;} public void setExamenFecha(LocalDate f){this.examenFecha=f;}
    public int getIdGrado(){return idGrado;} public void setIdGrado(int g){this.idGrado=g;}
    public int getIdSeccion(){return idSeccion;} public void setIdSeccion(int s){this.idSeccion=s;}
    public int getIdAula(){return idAula;} public void setIdAula(int a){this.idAula=a;}
    public String getAulaCodigo(){return aulaCodigo;} public void setAulaCodigo(String a){this.aulaCodigo=a;}
}
