
-- looking at total of cases vs total deaths 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project JL].dbo.CovidDeaths
where location like '%Canada%'
order by date

-- looking at total cases vs Population 
-- shows what percentage of population got Covid

Select Location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
from [Portfolio Project JL].dbo.CovidDeaths
where location like '%Canada%'
order by date

-- Country that has the highest rate infection compared to population
Select Location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from [Portfolio Project JL].dbo.CovidDeaths
Group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population
Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project JL].dbo.CovidDeaths
where continent is not null
Group by location, population
order by TotalDeathCount desc

-- Looking things by continent 
Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project JL].dbo.CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

-- checking a few things/ not relevant  
Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project JL].dbo.CovidDeaths
where continent is null
Group by location
order by TotalDeathCount desc

-- GLOBAL NUMBERS
select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
from [Portfolio Project JL].dbo.CovidDeaths
--where location like '%Canada%'
where continent is not null 
group by date
order by date

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
from [Portfolio Project JL].dbo.CovidDeaths
--where location like '%Canada%'
where continent is not null 

-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
from [Portfolio Project JL].dbo.CovidDeaths dea
Join [Portfolio Project JL].dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

-- USE CTE

With PopvsVac (Continent, location, date, population, New_Vaccinatios, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
from [Portfolio Project JL].dbo.CovidDeaths dea
Join [Portfolio Project JL].dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

-- TEMP TABLE 

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated 
(
Continent nvarchar(225),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
from [Portfolio Project JL].dbo.CovidDeaths dea
Join [Portfolio Project JL].dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location,
	dea.date) as RollingPeopleVaccinated
from [Portfolio Project JL].dbo.CovidDeaths dea
Join [Portfolio Project JL].dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select *
From PercentPopulationVaccinated