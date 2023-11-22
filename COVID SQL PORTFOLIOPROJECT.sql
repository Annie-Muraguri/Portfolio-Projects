SELECT *
From PortfolioProject..CovidDeaths$
order by 3,4

--select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4

SELECT Location ,date ,total_cases ,new_cases,total_deaths ,population
From PortfolioProject..CovidDeaths$
Order by 1,2

SELECT Location ,date ,total_cases,total_deaths ,(total_deaths/total_cases)*100 as deathpercentage
From PortfolioProject..CovidDeaths$
Order by 1,2

SELECT LOCATION,DATE,TOTAL_CASES,POPULATION,(TOTAL_CASES/POPULATION)*100 AS DEATHPERCENTAGE
From PortfolioProject..CovidDeaths$
WHERE LOCATION LIKE '%AFRICA%'
Order by 1,2


SELECT LOCATION,POPULATION,TOTAL_CASES,(TOTAL_CASES/POPULATION)*100 AS PERCENTPOPULATIONINFECTED
From PortfolioProject..CovidDeaths$
WHERE LOCATION LIKE '%AFRICA%'
Order by 1,2

SELECT LOCATION,POPULATION,MAX(TOTAL_CASES) AS HIGHESTINFECTIONCOUNT,MAX((TOTAL_CASES/POPULATION))*100 AS PERCENTPOPULATIONINFECTED
From PortfolioProject..CovidDeaths$
--WHERE LOCATION LIKE '%Africa%'
Group By location , population
Order by PERCENTPOPULATIONINFECTED desc

SELECT LOCATION,max (Cast(Total_deaths as int))as TotalDeathCount
From PortfolioProject..CovidDeaths$
--WHERE LOCATION LIKE '%states%'
Where continent is not Null
Group By location 
Order by TotalDeathCount desc

SELECT continent,max (Cast(Total_deaths as int))as TotalDeathCount
From PortfolioProject..CovidDeaths$
--WHERE LOCATION LIKE '%states%'
Where continent is not Null
Group By continent 
Order by TotalDeathCount desc

SELECT Location ,date ,total_cases,total_deaths ,(total_deaths/total_cases)*100 as deathpercentage
From PortfolioProject..CovidDeaths$
Order by 1,2

SELECT date, SUM (new_cases), SUM(cast(new_deaths as int)),SUM(cast(new_deaths as int)) /SUM( new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
--WHERE LOCATION LIKE '%states%'
Where continent is not Null
Group by date
Order by 1,2


select dea.continent ,dea.location ,dea.date ,dea.population ,vac.new_vaccinations
From PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date =vac.date
  Where dea.continent is not null
  Order by 2,3

select dea.continent ,dea.location ,dea.date ,dea.population ,vac.new_vaccinations ,sum(convert(int, vac.new_vaccinations)) 
over (partition by dea.location order by dea.location ,dea.date) as ROLLINGPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date =vac.date
  Where dea.continent is not null
  Order by 2,3
  
With PopvsVac(continent,location,date,population, new_vaccinations,Rollingpeoplevaccinated)as
(
Select dea.continent ,dea.location ,dea.date ,dea.population ,vac.new_vaccinations ,sum(convert(int, vac.new_vaccinations)) 
over (partition by dea.location order by dea.location ,dea.date) as ROLLINGPeopleVaccinated
--,(Rollingpeoplevaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date =vac.date
  Where dea.continent is not null
 -- Order by 2,3
  )
  select*,(Rollingpeoplevaccinated/population)*100
  From PopvsVac

create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
 Insert into #PercentPopulationVaccinated 
Select dea.continent ,dea.location ,dea.date ,dea.population ,vac.new_vaccinations ,sum(convert(int, vac.new_vaccinations)) 
over (partition by dea.location order by dea.location ,dea.date) as ROLLINGPeopleVaccinated
--,(Rollingpeoplevaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date =vac.date
  Where dea.continent is not null
 -- Order by 2,3
 
 select*, (ROLLINGPeopleVaccinated /population)*100
  From #PercentPopulationVaccinated

  Create view percentpopulationvaccinated as
  select dea.continent ,dea.location ,dea.date ,dea.population ,vac.new_vaccinations ,sum(convert(int, vac.new_vaccinations)) 
over (partition by dea.location order by dea.location ,dea.date) as ROLLINGPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
 join PortfolioProject..CovidVaccinations vac
  on dea.location= vac.location
  and dea.date =vac.date
  Where dea.continent is not null
 -- Order by 2,3