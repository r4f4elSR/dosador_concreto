# Dosador de Concreto

Aplicativo multiplataforma desenvolvido em Flutter para auxiliar no cálculo de dosagens de concreto.

O aplicativo permite criar, armazenar e consultar traços de concreto, além de realizar a dosagem dos materiais a partir de um traço previamente definido.

## Funcionalidades

* Criação e armazenamento de traços de concreto
* Dosagem de concreto a partir de traços cadastrados
* Cálculo das quantidades dos materiais
* Suporte a unidades de medida personalizadas
* Armazenamento local dos dados
* Interface responsiva
* Suporte a múltiplas plataformas

## Plataformas

O projeto foi desenvolvido com Flutter e pode ser executado em:

* Android
* Windows
* Web
* Linux
* macOS
* iOS

> A disponibilidade e os testes de cada plataforma podem variar conforme a versão do aplicativo.

## Tecnologias utilizadas

* Flutter
* Dart
* Hive CE
* Material Design

## Armazenamento de dados

Os dados do aplicativo são armazenados localmente utilizando Hive CE.

Nenhum dado de traços ou dosagens é enviado para servidores externos.

## Como executar o projeto

### Pré-requisitos

É necessário ter o Flutter instalado e configurado.

Verifique a instalação executando:

```bash
flutter doctor
```

### Clone o repositório

```bash
git clone https://github.com/r4f4elSR/dosador_concreto.git
```

Entre na pasta do projeto:

```bash
cd dosador_concreto
```

Instale as dependências:

```bash
flutter pub get
```

Execute o aplicativo:

```bash
flutter run
```

## Build

### Android

```bash
flutter build apk
```

### Windows

```bash
flutter build windows
```

### Web

```bash
flutter build web
```

## Estrutura do projeto

```text
lib/
├── assets/
├── dialogs/
├── models/
├── pages/
├── widgets/
└── main.dart
```

A estrutura pode variar conforme a evolução do projeto.

## Versão

Versão atual:

```text
1.0.0
```

## Aviso

Os resultados fornecidos pelo aplicativo são ferramentas auxiliares de cálculo.

A definição e a utilização de traços de concreto devem considerar as características dos materiais, os requisitos de projeto, as normas técnicas aplicáveis e a avaliação de um profissional qualificado.

## Autor

Desenvolvido por Rafael Rodrigues.

## Licença

Este projeto não possui uma licença de código aberto definida.

Todos os direitos são reservados ao autor.
