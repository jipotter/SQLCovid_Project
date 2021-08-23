--%death of country
SELECT location,date , population, total_deaths AS DeathCount, (total_deaths/population)*100 AS DeathPercent
From CovidDeath
order by 1,2 



--%highlest death  of country
SELECT location , population, MAX(total_deaths) AS DeathCount, MAX(total_deaths/population)*100 AS DeathPercent
From CovidDeath
group by location, population 
order by DeathPercent desc 

--%got covid of country
SELECT location,date , population, total_cases AS CovidCount, (total_cases/population)*100 AS GotcovidPercent
From CovidDeath
order by 1,2 

--%highlest got covid of country
SELECT location , population, MAX(total_cases ) AS CovidCount, MAX(total_cases/population)*100 AS GotcovidPercent
From CovidDeath
group by location, population 
order by GotcovidPercent desc 

--highlest death count of country
SELECT location , MAX(total_deaths) AS DeathCount
From CovidDeath
group by location
HAVING location <>'World' AND  location <>'Europe' AND location <>'South America' AND location <>'Asia' 
	AND location <>'North America' AND location <>'European Union'
order by DeathCount desc

--highlest got covid count of country
SELECT location , MAX(total_cases) AS CovidCount
From CovidDeath
group by location
HAVING location <>'World' AND  location <>'Europe' AND location <>'South America' AND location <>'Asia' 
	AND location <>'North America' AND location <>'European Union'
order by CovidCount desc

--highlest death count of connteint
SELECT continent , MAX(total_deaths) AS DeathCount
From CovidDeath
where continent is not NULL
group by continent
order by DeathCount desc

--cases covid and death per day from entire world
SELECT date, SUM(new_cases) AS total_Cases, SUM(new_deaths) As Total_Deaths
FROM CovidDeath
group by date
order by date

--join CovidDeath table and CovidVaccinations table
SELECT * 
FROM CovidDeath AS CD
JOIN CovidVaccinations AS CV
On CD.date = CV.date and CD.location = CV.location
Order by CD.location,CD.date

--show population vs vaccinations per country and day
SELECT CD.continent, CD.location,CD.date ,CD.population , CV.new_vaccinations
FROM CovidDeath AS CD
JOIN CovidVaccinations AS CV
On  CD.location = CV.location AND CD.date = CV.date 
Where CD.continent is not NULL 
Order by 2,3


--show cumulative people Vaccination and percent vaccination per day
With vac(conteinent, location , date , population, vaccination , CumulativePeopleVaccination)
as(
SELECT CD.continent, CD.location, CD.date , CD.population , CV.new_vaccinations, 
		SUM(new_vaccinations) OVER (Partition by CD.location order by CD.date) AS CumulativePeopleVaccination
		
FROM CovidDeath AS CD
JOIN CovidVaccinations AS CV
On  CD.location = CV.location AND CD.date = CV.date 
Where CD.continent is not NULL 
--Order by 2,3
)
SELECT *, (CumulativePeopleVaccination/population)*100 AS CumulativeVaccinePercent
FROM vac
Order by location , date

--create view from visualization
Create view PeopleVaccination AS
SELECT CD.continent, CD.location, CD.date , CD.population , CV.new_vaccinations, 
		SUM(new_vaccinations) OVER (Partition by CD.location order by CD.date) AS CumulativePeopleVaccination
FROM CovidDeath AS CD
JOIN CovidVaccinations AS CV
On  CD.location = CV.location AND CD.date = CV.date 
Where CD.continent is not NULL 



SELECT * FROM PeopleVaccination

