#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ, Замещение)          
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;  
	УказыватьОтветственного = Не ДополнительныеСвойства.Свойство("НеИзменятьОтветственного");
	ДатаФиксации = ТекущаяДатаСеанса();
	Пользователь = Пользователи.ТекущийПользователь();
	Для каждого Запись Из ЭтотОбъект Цикл
		Если УказыватьОтветственного Тогда
			УказатьОтветственного(Запись, ДатаФиксации, Пользователь);
		КонецЕсли;  
		ЗаменитьПустыеПоля(Запись);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УказатьОтветственного(Запись, Период, Ответственный)
	Запись.ДатаФиксации = Период;
	Запись.Ответственный = Ответственный;
КонецПроцедуры

Процедура ЗаменитьПустыеПоля(Запись)
	ПроверитьЗаменить(Запись, "Перевозчик");
	ПроверитьЗаменить(Запись, "МаркаТС");
	ПроверитьЗаменить(Запись, "РегистрационныйНомерПрицепа");
	ПроверитьЗаменить(Запись, "Заказчик");
	ПроверитьЗаменить(Запись, "Экспедитор");
	Если Не Запись.ТипДоставки = "413" Тогда
		ПроверитьЗаменить(Запись, "Водитель");
		ПроверитьЗаменить(Запись, "РегистрационныйНомерТС");
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьЗаменить(Запись, ИмяПоля)
	Если ПустаяСтрока(Запись[ИмяПоля]) Тогда 
		Запись[ИмяПоля] = "-";
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
