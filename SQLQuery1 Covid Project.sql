-- Checking All The Data
Select *
From PortfolioProjects..CovidDeaths
order by 3,4



-- Checking Specific Data we will focus on
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjects..CovidDeaths
order by 1,2


-- Total Cases vs Total Deaths
-- Likelihood of dying if you contract covid in United States
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjects..CovidDeaths
Where Location = 'United States'
order by 1,2

-- Total Cases vs Population
-- Percentage of population with Covid
Select Location, date, population, total_cases, (total_cases/Population)*100 as InfectionRate
From PortfolioProjects..CovidDeaths
Where Location = 'United States'
order by 1,2

-- Countries with Highest Infection Rate compared to Population
Select Location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/Population))*100 as InfectionRate
From PortfolioProjects..CovidDeaths
Group By Location, population
Order by InfectionRate desc


-- Countries with Highest Death Count per Population
Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDeaths
Where continent is not null
Group By Location
Order by TotalDeathCount desc

-- Highest Death Count Per Continent
Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDeaths
Where continent is null
Group By Location
Order by TotalDeathCount desc


-- Global Numbers

Select Sum(new_cases) as Total_Cases, Sum(cast(new_deaths as int)) as Total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProjects..CovidDeaths
Where continent is not null
order by 1,2



-- Joining the two tables vac and deaths
Select *
From PortfolioProjects..CovidDeaths as dea
Join PortfolioProjects..CovidVaccinations as vac
  On dea.location = vac.location
  and dea.date = vac.date


-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, population, dea.date, vac.new_vaccinations
From PortfolioProjects..CovidDeaths as dea
Join PortfolioProjects..CovidVaccinations as vac
  On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
order by 2,3

-- Create column with Continous counting people vaccinated (CCPV)
Select dea.continent, dea.location, population, dea.date, vac.new_vaccinations, Sum(cast(vac.new_vaccinations as int)) OVER (Partition By dea.Location Order By dea.location, dea.date) as CountingPeopleVaccinated
From PortfolioProjects..CovidDeaths as dea
Join PortfolioProjects..CovidVaccinations as vac
  On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
order by 1,2,3

