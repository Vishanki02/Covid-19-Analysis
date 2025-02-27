Select*
From PortfolioProject_covid19..CovidDeaths$
where continent is not null
order by 3,4

--Select*
--From PortfolioProject_covid19..CovidVaccinations$
--order by 3,4

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject_covid19..CovidDeaths$
where location like '%india%'
and continent is not null
order by 1,2


--loking at total cases vs population

Select Location, date, population, total_cases,(total_cases/population)*100 as PercentagePopulationInfected
From PortfolioProject_covid19..CovidDeaths$
--where location like '%india%'

order by 1,2



--looking at countries with highest infection ratecompared to population

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))  *100 as PercentagePopulationInfected
From PortfolioProject_covid19..CovidDeaths$
--where location like '%india%'
Group by  Location, population
order by PercentagePopulationInfected desc



--showing countires with highest death count per popultion

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject_covid19..CovidDeaths$
--where location like '%india%'
where continent is not null
Group by  Location
order by TotalDeathCount desc



--lets break things down by continents

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject_covid19..CovidDeaths$
--where location like '%india%'
where continent is not null
Group by  continent
order by TotalDeathCount desc


--showing continents with the highest death count pepr population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject_covid19..CovidDeaths$
--where location like '%india%'
where continent is not null
Group by  continent
order by TotalDeathCount desc


--global numbers

Select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as  total_deaths  , SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage--, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject_covid19..CovidDeaths$
--where location like '%india%'
where continent is not null
--Group by date
order by 1,2
 


 with PopvsVac(Continent,Location, Date, Population, new_vaccinations,RollingPeopleVaccinated)
 as 
 (
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location ORDER by dea.location,dea.Date) as RollingPeopleVaccinated--,(RollingPeopleVaccinated/population)*100
 From PortfolioProject_covid19..CovidDeaths$ dea
 Join PortfolioProject_covid19..CovidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3
	)
	SElect*, (RollingPeopleVaccinated/population)*100
	From PopvsVac

	
	
	--Temp Table
	Drop Table if exists #PercentPopulationVaccinated
	Create Table #PercentPopulationVaccinated
	(
	Continent nvarchar(255),
	Location  nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
	)

	
	Insert into #PercentPopulationVaccinated
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location ORDER by dea.location,dea.Date) as RollingPeopleVaccinated--,(RollingPeopleVaccinated/population)*100
    From PortfolioProject_covid19..CovidDeaths$ dea
    Join PortfolioProject_covid19..CovidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
	--where dea.continent is not null
	--order by 2,3
	
	Select*,(RollingPeopleVaccinated/Population)*100
	From #PercentPopulationVaccinated

   
   --create view to store data for later visualization

   Create view PercentPopulationVaccinated as
   Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location ORDER by dea.location,dea.Date) as RollingPeopleVaccinated--,(RollingPeopleVaccinated/population)*100
    From PortfolioProject_covid19..CovidDeaths$ dea
    Join PortfolioProject_covid19..CovidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3