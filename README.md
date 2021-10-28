# Getting started

PsPassManager est un module créer pour stocker vos identifiants (Windows / Powershell / M365 par exemple)

## Read the doc

Non disponible pour l'instant

## Download

Download latest realease: [github.com/HiteaFR/PsPassManager/releases/latest](https://github.com/HiteaFR/PsPassManager/releases/latest)

## Requirements

### Minimal

- Windows 7 SP1 / Windows Server 2008 R2 SP1

- [Windows Management Framework 5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616)

### Recommended

- Windows 10 / Windows Server 2016 / Windows Server 2019

## Installation

### From PowerShell Gallery

Non disponible pour l'instant

### From Source

Clone the repository :

```
    Git clone https://github.com/HiteaFR/PsPassManager.git
```

Or download the latest release : [github.com/HiteaFR/PsPassManager/releases/latest](https://github.com/HiteaFR/PsPassManager/releases/latest)

Run Powershell as Administrator :

```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force

    Import-Module -FullyQualifiedName [CHEMIN_VERS_LE_MODULE] -Force -Verbose
```

## Usage

```powershell
    # Enregistrer un identifiant
    Ppm new
    # Enregistrer sans ui
    Ppm new <Username> <Password>
```

```powershell
    # Afficher les identifiants sauvegardés et obtenir le mot de passe en clair
    Ppm get
    # Obtenir l'objet credential pour un identifiant
    Ppm get <Username>
```

Voir toute la doc : Non disponible pour l'instant
