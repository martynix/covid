select *
from covid..CovidDeaths
where continent is not null
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
and continent is not null
order by 1,2


-- total cases vs population
-- what percentage of population got covid

select Location, date, Population, total_cases, (total_cases/population)*100 as PopulationInfectedPercentage
from covid..CovidDeaths
where continent is not null
order by 1,2


-- countries with highest infection rate compared to population

select Location, Population, MAX(total_cases) as HighestInfectionRate, MAX((total_cases/population))*100 as PopulationInfectedPercentage
from covid..CovidDeaths
where continent is not null
group by Location, Population
order by PopulationInfectedPercentage desc


-- countries with the highest death count per population
-- total deaths is varchar so we need to convert it to int by using cast function

select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from covid..CovidDeaths
where continent is not null -- to choose only countries, not whole continents
group by Location
order by TotalDeathCount desc


-- continens with the highest death count per population

select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from covid..CovidDeaths
where continent is null -- to choose only countries, not whole continents
group by Location
order by TotalDeathCount desc


-- by continent
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from covid..CovidDeaths
where continent is not null -- to choose only countries, not whole continents
group by continent
order by TotalDeathCount desc


-- continents with the highest death count per population

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from covid..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


-- global numbers

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from covid..CovidDeaths
--where location = 'Poland'
where continent is not null
--group by date
order by 1,2


-- total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from covid..CovidDeaths dea
Join covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--use cte

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From covid..CovidDeaths dea
Join covid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac