#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// Регистрируем сообщение к выгрузке только из регламентного задания
	ДополнительныеСвойства.Вставить("адаптер_ЭтоЗагрузкаДанных", Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
