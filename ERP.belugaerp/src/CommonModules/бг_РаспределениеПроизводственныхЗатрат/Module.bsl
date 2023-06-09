#Область ПрограммныйИнтерфейс

Процедура бг_РаспределитьМатериалыПоПартиямПроизводства(Документ,
					Знач КоличествоРаспределить, Знач БазаРаспределенияМатериалов, СтатьяКалькуляции = Неопределено) Экспорт
	Если БазаРаспределенияМатериалов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Коэффициент = БазаРаспределенияМатериалов.Итог("Коэффициент");
	Если Коэффициент = 0 Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Некорректно передана база распределения'"));
		Возврат;
	КонецЕсли;
	
	Документ.ПартииПроизводства.Очистить();
	Документ.Количество = КоличествоРаспределить;
	
	ОписаниеТипаКоличество = ОбщегоНазначения.ОписаниеТипаЧисло(15, 3, ДопустимыйЗнак.Неотрицательный);
	
	Для Каждого СтрокаБазаРаспределения Из БазаРаспределенияМатериалов Цикл
		КоличествоРаспределено = ОписаниеТипаКоличество.ПривестиЗначение(КоличествоРаспределить / Коэффициент * СтрокаБазаРаспределения.Коэффициент);
		
		КоличествоРаспределить = КоличествоРаспределить - КоличествоРаспределено;
		Коэффициент = Коэффициент - СтрокаБазаРаспределения.Коэффициент;
		
		Если КоличествоРаспределено = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрокаПартияПроизводства = Документ.ПартииПроизводства.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаПартияПроизводства, СтрокаБазаРаспределения);
		НоваяСтрокаПартияПроизводства.Этап = СтрокаБазаРаспределения.Распоряжение;
		НоваяСтрокаПартияПроизводства.Количество = КоличествоРаспределено;
		
		Если СтатьяКалькуляции <> Неопределено Тогда
			НоваяСтрокаПартияПроизводства.СтатьяКалькуляции = СтатьяКалькуляции;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
