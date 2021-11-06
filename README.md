# Intro

PsPassManager est un module créer pour stocker vos identifiants (Windows / Powershell / M365 par exemple)

Venez nous soutenir sur les Réseaux et Youtube :)

- [Hitea.fr](https://hitea.fr/)
- [Youtube](https://www.youtube.com/channel/UCt30dovkjqINMeh0p5DUoVQ?sub_confirmation=1)
- [Facebook](https://www.facebook.com/hitea.fr)
- [Twitter](https://twitter.com/HiteaFR)
- [Linkedin](https://www.linkedin.com/company/hitea-fr)
- [GitHub](https://github.com/HiteaFR)

## Documentation

Toute la documentation: [HiteaFR.github.io/PsPassManager](https://HiteaFR.github.io/PsPassManager)

## Prérequis

Windows 10+ / Windows Server 2016+

### AMSI

Si votre antivirus utilise l'intégration d’analyse de logiciel anti-programmes malveillants (AMSI)

Il faudra déactiver la fonctionnalité si les fonctions de chiffrement sont bloquées.

## Installation

### PowerShell Gallery

Page du Module: [powershellgallery.com/packages/PsPassManager](https://www.powershellgallery.com/packages/PsPassManager

```powershell
    Install-Module -Name PsPassManager
```

### Dépot Git

```powershell
    Git clone https://github.com/HiteaFR/PsPassManager.git

    Set-ExecutionPolicy Bypass -Scope Process -Force

    Import-Module -FullyQualifiedName [CHEMIN_VERS_LE_MODULE] -Force -Verbose
```

### Téléchargement

Télécharger la dernière version : [github.com/HiteaFR/PsPassManager/releases/latest](https://github.com/HiteaFR/PsPassManager/releases/latest)

```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force

    Import-Module -FullyQualifiedName [CHEMIN_VERS_LE_MODULE] -Force -Verbose
```

## Utilisation

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

Voir toute la doc : : [HiteaFR.github.io/PsPassManager](https://HiteaFR.github.io/PsPassManager)
