#
#    Copyright 2010-2026 the original author or authors.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

FROM maven:3.8.7-eclipse-temurin-17 AS build
WORKDIR /app

# Étape cache : télécharger les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier le reste du projet
COPY . .
RUN mvn package -DskipTests

# Le projet est packagé en WAR (voir pom.xml). Déployer le WAR dans Tomcat.
FROM tomcat:9.0-jdk17
WORKDIR /usr/local/tomcat/webapps

# Copier le WAR généré et le déployer (conserver le nom pour le contexte /jpetstore)
COPY --from=build /app/target/jpetstore.war jpetstore.war

EXPOSE 8080
# Le container Tomcat officiel démarre Tomcat via son CMD par défaut.






