package model;

import java.io.Serializable;
import java.time.LocalDate;
import util.NombreUtil;

public class Alumno implements Serializable {
    private int id;
    private String nombres;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private String dni;
    private LocalDate fechaNacimiento;
    private String celular;
    private String direccion;
    private int idGrado;
    private int idSeccion;
    private int idCarrera;
    private String gradoNombre;
    private String seccionNombre;
    private String carreraNombre;
    private String colegio;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombres() { return NombreUtil.nombres(nombres); }
    public void setNombres(String nombres) { this.nombres = nombres; }

    public String getApellidoPaterno() { return NombreUtil.apellidos(apellidoPaterno); }
    public void setApellidoPaterno(String apellidoPaterno) { this.apellidoPaterno = apellidoPaterno; }

    public String getApellidoMaterno() { return NombreUtil.apellidos(apellidoMaterno); }
    public void setApellidoMaterno(String apellidoMaterno) { this.apellidoMaterno = apellidoMaterno; }

    public String getDni() { return dni; }
    public void setDni(String dni) { this.dni = dni; }

    public LocalDate getFechaNacimiento() { return fechaNacimiento; }
    public void setFechaNacimiento(LocalDate fechaNacimiento) { this.fechaNacimiento = fechaNacimiento; }

    public String getCelular() { return celular; }
    public void setCelular(String celular) { this.celular = celular; }

    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }

    public int getIdGrado() { return idGrado; }
    public void setIdGrado(int idGrado) { this.idGrado = idGrado; }

    public int getIdSeccion() { return idSeccion; }
    public void setIdSeccion(int idSeccion) { this.idSeccion = idSeccion; }

    public int getIdCarrera() { return idCarrera; }
    public void setIdCarrera(int idCarrera) { this.idCarrera = idCarrera; }

    public String getGradoNombre() { return gradoNombre; }
    public void setGradoNombre(String gradoNombre) { this.gradoNombre = gradoNombre; }

    public String getSeccionNombre() { return seccionNombre; }
    public void setSeccionNombre(String seccionNombre) { this.seccionNombre = seccionNombre; }

    public String getCarreraNombre() { return carreraNombre; }
    public void setCarreraNombre(String carreraNombre) { this.carreraNombre = carreraNombre; }

    public String getColegio() { return colegio; }
    public void setColegio(String colegio) { this.colegio = colegio; }

    public String getNombreCompleto() {
        return NombreUtil.completo(apellidoPaterno, apellidoMaterno, nombres);
    }
}