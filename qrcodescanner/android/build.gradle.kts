buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Оставил твои версии, они стабильные
        classpath("com.android.tools.build:gradle:8.2.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.22")
        classpath("com.google.gms:google-services:4.4.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    // ФИКС ПУТЕЙ: заставляет все плагины и приложение строиться в общую папку build
    buildDir = file("${rootProject.projectDir}/../build/${project.name}")
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}