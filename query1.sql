select *
from covid..CovidDeaths
order by 3,4

select *
from covid..CovidVaccinations
order by 3,4

select Location, date, total_cases, new_cases, total_deaths,population
from covid..CovidDeaths
order by 1,2



-- total cases vs total deaths
-- likelihood of dying if you get sick in Poland

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covid..CovidDeaths
--where location = 'Poland'
order by 1,2


-- total cases vs population
-- what percentage of population got covid

select Location, date, Population, total_cases, (total_cases/population)*100 as PopulationInfectedPercentage
from covid..CovidDeaths
--where location = 'Poland'
order by 1,2


-- countries with highest infection rate compared to population

select Location, Population, MAX(total_cases) as HighestInfectionRate, MAX((total_cases/population))*100 as PopulationInfectedPercentage
from covid..CovidDeaths
--where location = 'Poland'
group by Location, Population
order by PopulationInfectedPercentage desc


-- countries with the highest death count per population
-- total deaths is varchar so we need to convert it to int by using cast function

select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from covid..CovidDeaths
--where location = 'Poland'
group by Location
order by TotalDeathCount desc