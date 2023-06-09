#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Обработка смены реквизитов.
	Если ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("СинхронизироватьРегламентныеЗаданияФормированияЗаказов");
	Иначе
		ПроверяемыеРеквизиты = Новый Структура("ПометкаУдаления,Организация");
		ИзмененныеРеквизиты = бг_ОбщегоНазначенияСервер.ИзмененияОбъекта(
			ЭтотОбъект,
			ПроверяемыеРеквизиты);
		Если ИзмененныеРеквизиты.Свойство("Реквизиты")
			И ИзмененныеРеквизиты.Реквизиты.Количество() > 0 Тогда
			ДополнительныеСвойства.Вставить("СинхронизироватьРегламентныеЗаданияФормированияЗаказов");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И ДополнительныеСвойства.Свойство("СинхронизироватьРегламентныеЗаданияФормированияЗаказов") Тогда
		бг_РегламентныеЗадания.СинхронизироватьРегламентныеЗаданияФормированияЗаказов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
