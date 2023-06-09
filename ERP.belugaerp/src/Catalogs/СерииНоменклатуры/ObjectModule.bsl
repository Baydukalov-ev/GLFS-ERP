#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ПередЗаписью")
Процедура бг_ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	бг_ЗаполнитьПолныеНачалоКонецДиапазона();
	бг_ЗаполнитьСертификат();
	бг_ЗаполнитьВидМарки();
	бг_ЗаполнитьДатуГенерации();
	бг_ЗаполнитьОрганизациюВладельцаЕГАИС();
	бг_ЗаполнитьПризнакГотоваяПродукция();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура бг_ЗаполнитьПолныеНачалоКонецДиапазона()
	УстановитьПривилегированныйРежим(Истина);
	
	Если ВидНоменклатуры <> бг_КонстантыПовтИсп.ЗначениеКонстанты("ФедеральнаяСпецМарка") Тогда
		Возврат;
	КонецЕсли;
	
	ТипАкцизнойМарки = бг_ТипАкцизнойМарки();
	
	ШаблонПолныйНомер = "%1%2%3";
	бг_ПолныйНачальныйНомерДиапазона = СтрШаблон(ШаблонПолныйНомер, ТипАкцизнойМарки, Формат(бг_СерияМарки, "ЧЦ=3; ЧВН="), Формат(бг_НачальныйНомерДиапазона, "ЧЦ=8; ЧВН=; ЧГ=0"));
	бг_ПолныйКонечныйНомерДиапазона  = СтрШаблон(ШаблонПолныйНомер, ТипАкцизнойМарки, Формат(бг_СерияМарки, "ЧЦ=3; ЧВН="), Формат(бг_КонечныйНомерДиапазона, "ЧЦ=8; ЧВН=; ЧГ=0"));
КонецПроцедуры

Функция бг_ТипАкцизнойМарки()
	ТипАкцизнойМарки = "";
	
	Если Не ЗначениеЗаполнено(бг_Номенклатура) Тогда
		Возврат ТипАкцизнойМарки;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕстьNull(Номенклатура.бг_ТипМарки.Код, """") КАК ТипМаркиКод
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", бг_Номенклатура);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ТипАкцизнойМарки = Выборка.ТипМаркиКод;
	КонецЕсли;
	
	Возврат ТипАкцизнойМарки;
КонецФункции

Процедура бг_ЗаполнитьСертификат()
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(бг_Сертификат) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(бг_Номенклатура) Тогда
		бг_Сертификат = Неопределено;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	СертификатыНоменклатуры.Ссылка КАК СертификатНоменклатуры
	|ИЗ
	|	РегистрСведений.ОбластиДействияСертификатовНоменклатуры КАК ОбластиДействияСертификатовНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СертификатыНоменклатуры КАК СертификатыНоменклатуры
	|		ПО (ОбластиДействияСертификатовНоменклатуры.Номенклатура = &Номенклатура)
	|			И ОбластиДействияСертификатовНоменклатуры.СертификатНоменклатуры = СертификатыНоменклатуры.Ссылка
	|			И (СертификатыНоменклатуры.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСертификатовНоменклатуры.Действующий))
	|			И (СертификатыНоменклатуры.ДатаНачалаСрокаДействия <= &ДатаПроизводства)
	|			И (СертификатыНоменклатуры.ДатаОкончанияСрокаДействия >= &ДатаПроизводства
	|				ИЛИ СертификатыНоменклатуры.ДатаОкончанияСрокаДействия = ДАТАВРЕМЯ(1, 1, 1))
	|			И (НЕ СертификатыНоменклатуры.ПометкаУдаления)";
	Запрос.УстановитьПараметр("Номенклатура", бг_Номенклатура);
	Запрос.УстановитьПараметр("ДатаПроизводства", ДатаПроизводства);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		бг_Сертификат = Выборка.СертификатНоменклатуры;
	Иначе
		бг_Сертификат = Неопределено;
	Конецесли;
КонецПроцедуры

Процедура бг_ЗаполнитьВидМарки()

	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(бг_ВидМарки) Тогда
		Возврат;
	КонецЕсли;
	
	ОсобенностьУчетаВидаНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидНоменклатуры, "ОсобенностьУчета");	
	Если ОсобенностьУчетаВидаНоменклатуры = Перечисления.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция Тогда 
		бг_ВидМарки = Справочники.бг_КлассификаторВидовМарок.ВидМаркиПоУмолчанию();
	КонецЕсли;
		
КонецПроцедуры

Процедура бг_ЗаполнитьДатуГенерации()
	
	Если Не ЗначениеЗаполнено(бг_ДатаГенерации) Тогда
		бг_ДатаГенерации = ТекущаяДатаСеанса();
	КонецЕсли;
	
КонецПроцедуры

Процедура бг_ЗаполнитьОрганизациюВладельцаЕГАИС()

	Если ЗначениеЗаполнено(бг_ОрганизацияЕГАИСВладелец) Тогда
		Возврат;
	КонецЕсли;

	Если ДополнительныеСвойства.Свойство("бг_ОрганизацияЕГАИСВладелец")
		И ЗначениеЗаполнено(ДополнительныеСвойства.бг_ОрганизацияЕГАИСВладелец) Тогда
		
		бг_ОрганизацияЕГАИСВладелец = ДополнительныеСвойства.бг_ОрганизацияЕГАИСВладелец;
	Иначе
		ТипыДокументовВыпуска = Новый Массив;
		ТипыДокументовВыпуска.Добавить(Тип("ДокументСсылка.СборкаТоваров"));
		ТипыДокументовВыпуска.Добавить(Тип("ДокументСсылка.ПроизводствоБезЗаказа"));
		ТипыДокументовВыпуска.Добавить(Тип("ДокументСсылка.ЭтапПроизводства2_2"));
		
		Если ЗначениеЗаполнено(бг_ДокументВыпуска)
			И ТипыДокументовВыпуска.Найти(ТипЗнч(бг_ДокументВыпуска)) <> Неопределено
			И ЗначениеЗаполнено(ПроизводительЕГАИС) Тогда
			
			бг_ОрганизацияЕГАИСВладелец = ПроизводительЕГАИС;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура бг_ЗаполнитьПризнакГотоваяПродукция()
	
	бг_ЭтоГотоваяПродукция = ЗначениеЗаполнено(бг_ДокументВыпуска);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
