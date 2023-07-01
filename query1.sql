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
where location = 'Poland'
order by 1,2


-- total cases vs population
-- what percentage of population got covid

select Location, date, Population, total_cases, (total_cases/population)*100 as PopulationPercentage
from covid..CovidDeaths
where location = 'Poland'
order by 1,2