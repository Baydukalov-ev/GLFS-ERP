#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ПередЗаписью")
Процедура бг_ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отбор.ГруппаПользователей.Использование
		И  Отбор.Пользователь.Использование Тогда
		
		Запрос = бг_ЗапросИсторияИзмененийЗапретаРедактирования();
		Выборка = Запрос.Выполнить().Выбрать();
		
		РегистрыСведений.бг_ИсторияИзмененийЗапретаРедактирования.ЗаписатьДанные(Выборка);
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция бг_ЗапросИсторияИзмененийЗапретаРедактирования()

	ГруппаПользователей = Отбор.ГруппаПользователей.Значение;
	Пользователь = Отбор.Пользователь.Значение;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СоставыГруппПользователей.ГруппаПользователей КАК ГруппаПользователей,
	|	СоставыГруппПользователей.Пользователь КАК Пользователь,
	|	СоставыГруппПользователей.Используется КАК Используется
	|ПОМЕСТИТЬ СоставыГруппПользователей
	|ИЗ
	|	&СоставыГруппПользователей КАК СоставыГруппПользователей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДатыЗапретаИзменения.Раздел КАК Раздел,
	|	ДатыЗапретаИзменения.Объект КАК Объект,
	|	СоставыГруппПользователей.ГруппаПользователей КАК ГруппаПользователей,
	|	СоставыГруппПользователей.Пользователь КАК Пользователь,
	|	ДатыЗапретаИзменения.ДатаЗапрета КАК ДатаЗапретаДо,
	|	ДатыЗапретаИзменения.ОписаниеДатыЗапрета КАК ОписаниеДатыЗапретаДо,
	|	НЕОПРЕДЕЛЕНО КАК ДатаЗапретаПосле,
	|	НЕОПРЕДЕЛЕНО КАК ОписаниеДатыЗапретаПосле
	|ПОМЕСТИТЬ ДатыЗапретаИзмененияДоПосле
	|ИЗ
	|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|		ПО ДатыЗапретаИзменения.Пользователь = СоставыГруппПользователей.ГруппаПользователей
	|			И (СоставыГруппПользователей.Используется)
	|ГДЕ
	|	СоставыГруппПользователей.ГруппаПользователей = &ГруппаПользователей
	|	И СоставыГруппПользователей.Пользователь = &Пользователь
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДатыЗапретаИзменения.Раздел,
	|	ДатыЗапретаИзменения.Объект,
	|	ДатыЗапретаИзменения.Пользователь,
	|	СоставыГруппПользователей.Пользователь,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	ДатыЗапретаИзменения.ДатаЗапрета,
	|	ДатыЗапретаИзменения.ОписаниеДатыЗапрета
	|ИЗ
	|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СоставыГруппПользователей КАК СоставыГруппПользователей
	|		ПО ДатыЗапретаИзменения.Пользователь = СоставыГруппПользователей.ГруппаПользователей
	|			И (СоставыГруппПользователей.Используется)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДатыЗапретаИзменения.Раздел КАК Раздел,
	|	ДатыЗапретаИзменения.Объект КАК Объект,
	|	&ГруппаПользователей КАК Пользователь,
	|	ДатыЗапретаИзменения.Пользователь КАК ПользовательКонечный,
	|	МАКСИМУМ(ДатыЗапретаИзменения.ДатаЗапретаДо) КАК ДатаЗапретаДо,
	|	МАКСИМУМ(ДатыЗапретаИзменения.ОписаниеДатыЗапретаДо) КАК ОписаниеДатыЗапретаДо,
	|	МАКСИМУМ(ДатыЗапретаИзменения.ДатаЗапретаПосле) КАК ДатаЗапретаПосле,
	|	МАКСИМУМ(ДатыЗапретаИзменения.ОписаниеДатыЗапретаПосле) КАК ОписаниеДатыЗапретаПосле,
	|	""Изменен состав группы пользователей"" КАК Комментарий,
	|	МАКСИМУМ(ДатыЗапретаИзменения.ГруппаПользователей) КАК ГруппаПользователей
	|ИЗ
	|	ДатыЗапретаИзмененияДоПосле КАК ДатыЗапретаИзменения
	|
	|СГРУППИРОВАТЬ ПО
	|	ДатыЗапретаИзменения.Раздел,
	|	ДатыЗапретаИзменения.Объект,
	|	ДатыЗапретаИзменения.Пользователь
	|
	|ИМЕЮЩИЕ
	|	(МАКСИМУМ(ДатыЗапретаИзменения.ДатаЗапретаДо) <> МАКСИМУМ(ДатыЗапретаИзменения.ДатаЗапретаПосле)
	|		ИЛИ МАКСИМУМ(ДатыЗапретаИзменения.ОписаниеДатыЗапретаДо) <> МАКСИМУМ(ДатыЗапретаИзменения.ОписаниеДатыЗапретаПосле))";
	
	Запрос.УстановитьПараметр("ГруппаПользователей", ГруппаПользователей);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("СоставыГруппПользователей", ЭтотОбъект.Выгрузить());
	
	Возврат Запрос;

КонецФункции

#КонецОбласти

#КонецЕсли
