from db import (Session, Trade)

session = Session()
ans = session.query(Trade).filter(Trade.uid == 3).all()
session.close()
for a in ans:
    print(a.title, a.user_trade_num)
print(ans)


trade = Trade(title="hello", uid=3, user_trade_num=34)
session = Session()
session.add(trade)
session.commit()
session.close()
