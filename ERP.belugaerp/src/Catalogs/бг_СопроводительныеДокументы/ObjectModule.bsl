#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыИзБД = Новый Структура("Вид, ПутьКФайлу",
		Справочники.бг_ВидыСопроводительныхДокументов.ПустаяСсылка(),
		"");
	Если Не ЭтоНовый() Тогда
		РеквизитыИзБД = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Вид, ПутьКФайлу");
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ВидПередЗаписью", РеквизитыИзБД.Вид);
	ДополнительныеСвойства.Вставить("ПутьКФайлуПередЗаписью", РеквизитыИзБД.ПутьКФайлу);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
