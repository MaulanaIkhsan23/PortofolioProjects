
select *
from PortofolioProject..CovidDeaths
where continent is not null
order by 3,4


--select *
--from PortofolioProject..CovidVaccinations
--order by 3,4


-- select data that we are going to using

select location, date, total_cases, new_cases, total_deaths, population
from PortofolioProject..CovidDeaths
where continent is not null
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- shows likelihood of dying if your conteact in your country

select location, date, total_cases,total_deaths, 
case
	when total_cases !=0 then (total_deaths/total_cases)*100 
	else null
end as deathpercentage
from PortofolioProject..CovidDeaths cov
where location like '%state%'
and continent is not null
order by 1,2


-- Looking at the Total Cases vs Popoulation
-- Shows what percentage of population got covid

select location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected
from PortofolioProject..CovidDeaths cov
--where location like '%state%'
order by 1,2


-- Looking at countries with highest infection rate compared to Population

select location, population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as PercentagePopulationInfected
from PortofolioProject..CovidDeaths cov
--where location like '%state%'
group by location, population
order by PercentagePopulationInfected desc


--Showing Countries with Highest Death Count per Population

select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortofolioProject..CovidDeaths cov
--where location like '%state%'
where continent is not null
group by location
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT

select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortofolioProject..CovidDeaths cov
--where location like '%state%'
where continent is not null
group by continent
order by TotalDeathCount desc


-- Showing continent with the Highest death count per population

select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortofolioProject..CovidDeaths cov
--where location like '%state%'
where continent is not null
group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS 

SELECT date, SUM(ISNULL(new_cases, 0)) AS total_cases, SUM(ISNULL(new_deaths, 0)) AS total_deaths,
CASE 
    WHEN SUM(ISNULL(new_cases, 0)) = 0 THEN NULL
    ELSE SUM(ISNULL(new_deaths, 0)) / SUM(ISNULL(new_cases, 0))*100
END AS deathpercentage
FROM PortofolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2


-- Looking at Total Population vs Vaccinations

select deat.continent, deat.location, deat.date, deat.population, vacc.new_vaccinations
, SUM(isnull(cast(vacc.new_vaccinations as bigint), 0)) OVER (Partition by deat.location order by deat.location, deat.date)
as RollingPeopleVaccinated
from PortofolioProject..CovidDeaths deat
join PortofolioProject..CovidVaccinations vacc
	on deat.location = vacc.location
	and deat.date = vacc.date
WHERE deat.continent IS NOT NULL
order by 2,3


--USE CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccination, RollingPeopleVaccinated)
as
(
select deat.continent, deat.location, deat.date, deat.population, vacc.new_vaccinations
, SUM(isnull(cast(vacc.new_vaccinations as bigint), 0)) OVER (Partition by deat.location order by deat.location, deat.date)
as RollingPeopleVaccinated
from PortofolioProject..CovidDeaths deat
join PortofolioProject..CovidVaccinations vacc
	on deat.location = vacc.location
	and deat.date = vacc.date
WHERE deat.continent IS NOT NULL
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date Datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)


Insert Into #PercentPopulationVaccinated
select deat.continent, deat.location, deat.date, deat.population, vacc.new_vaccinations
, SUM(isnull(cast(vacc.new_vaccinations as bigint), 0)) OVER (Partition by deat.location order by deat.location, deat.date)
as RollingPeopleVaccinated
from PortofolioProject..CovidDeaths deat
join PortofolioProject..CovidVaccinations vacc
	on deat.location = vacc.location
	and deat.date = vacc.date
WHERE deat.continent IS NOT NULL
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualisation

Create view PercentPopulationVaccinated as
select deat.continent, deat.location, deat.date, deat.population, vacc.new_vaccinations
, SUM(isnull(cast(vacc.new_vaccinations as bigint), 0)) OVER (Partition by deat.location order by deat.location, deat.date)
as RollingPeopleVaccinated
from PortofolioProject..CovidDeaths deat
join PortofolioProject..CovidVaccinations vacc
	on deat.location = vacc.location
	and deat.date = vacc.date
WHERE deat.continent IS NOT NULL
--order by 2,3

select *
from PercentPopulationVaccinated