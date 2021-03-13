import sqlalchemy as db

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine

import config

Base = declarative_base()
engine = create_engine(config.SQL_URL, echo=False)  # TODO: echo enable on debug

from .shopping import User

# import all tables

Base.metadata.create_all(engine)
Session = sessionmaker(bind=engine)
